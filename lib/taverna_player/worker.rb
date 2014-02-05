#------------------------------------------------------------------------------
# Copyright (c) 2013, 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

module TavernaPlayer
  class Worker
    include TavernaPlayer::Concerns::Callback
    include TavernaPlayer::Concerns::Zip

    attr_reader :run

    # How to get the interaction presentation frame out of the interaction page.
    INTERACTION_REGEX = /document\.getElementById\(\'presentationFrame\'\)\.src = \"(.+)\";/

    # The workflow file to be run can be specified explicitly or it will be
    # taken from the workflow model.
    def initialize(run, workflow_file = nil)
      @run = run
      @workflow = workflow_file || TavernaPlayer.workflow_proxy.file(@run.workflow)
    end

    # This tells delayed_job to only try and complete each run once.
    def max_attempts
      1
    end

    def perform
      unless TavernaPlayer.pre_run_callback.nil?
        status_message "Running pre-run tasks"
        callback(TavernaPlayer.pre_run_callback, @run)
      end

      status_message "Connecting to Taverna Server"

      server_uri = URI.parse(TavernaPlayer.server_address)
      credentials = T2Server::HttpBasic.new(TavernaPlayer.server_username,
        TavernaPlayer.server_password)
      conn_params = TavernaPlayer.server_connection

      begin
        server = T2Server::Server.new(server_uri, conn_params)
        wkf = File.read(@workflow)

        # Try and create the run bearing in mind that the server might be at
        # the limit of runs that it can hold at once.
        begin
          run = server.create_run(wkf, credentials)
        rescue T2Server::ServerAtCapacityError
          status_message "Server full - please wait; run will start soon"

          if cancelled?
            cancel
            return
          end

          sleep(TavernaPlayer.server_retry_interval)
          retry
        end

        status_message "Initializing new workflow run"

        @run.run_id = run.id
        @run.state = run.status
        @run.create_time = run.create_time
        @run.save

        unless @run.inputs.size == 0
          status_message "Uploading run inputs"
          @run.inputs.each do |input|
            unless input.file.blank?
              run.input_port(input.name).file = input.file.path
            else
              run.input_port(input.name).value = input.value
            end
          end
        end

        # Just add in all service credentials right now
        TavernaPlayer::ServiceCredential.all.each do |cred|
          run.add_password_credential(cred.uri, cred.login, cred.password)
        end

        status_message "Starting run"
        run.name = @run.name

        # Try and start the run bearing in mind that the server might be at
        # the limit of runs that it can run at once.
        while !run.start
          status_message "Server busy - please wait; run will start soon"

          if cancelled?
            cancel(run)
            return
          end

          sleep(TavernaPlayer.server_retry_interval)
        end

        @run.state = run.status
        @run.start_time = run.start_time
        @run.save

        status_message "Running"
        until run.finished?
          sleep(TavernaPlayer.server_poll_interval)
          waiting = false

          if cancelled?
            cancel(run)
            return
          end

          run.notifications(:requests).each do |note|
            if @run.has_parent?
              next if note.has_reply? || note.is_notification?
              int = Interaction.find_by_run_id_and_serial(@run.parent_id, note.serial)
              new_int = Interaction.find_or_initialize_by_run_id_and_serial(@run.id, note.serial)
              if new_int.new_record?
                note.reply(int.feed_reply, int.data)
                new_int.displayed = true
                new_int.replied = true
                new_int.feed_reply = int.feed_reply
                new_int.data = int.data
                new_int.save
              end
            else
              waiting = true unless note.has_reply?
              int = Interaction.find_or_initialize_by_run_id_and_serial(@run.id, note.serial)

              # Need to catch this here in case some other process has replied.
              if note.has_reply? && !int.replied?
                int.replied = true
                int.save
              end

              unless int.replied?
                if int.page.blank?
                  page = server.read(note.uri, "text/html", credentials)

                  INTERACTION_REGEX.match(page) do
                    page_uri = $1

                    if page_uri.starts_with?(server.uri.to_s)
                      page = server.read(URI.parse(page_uri), "text/html", credentials)
                      int.page = page.gsub("#{run.interactions_uri.to_s}/pmrpc.js",
                        "/assets/taverna_player/application.js")
                    else
                      int.page_uri = page_uri
                    end
                  end
                end

                if note.is_notification? && !int.new_record?
                  int.replied = true
                end

                if int.data.blank?
                  int.data = note.input_data.force_encoding("UTF-8")
                end

                if !int.feed_reply.blank? && !int.data.blank?
                  note.reply(int.feed_reply, int.data)

                  int.replied = true
                end

                int.save
              end
            end
          end

          status_message(waiting ? "Waiting for user input" : "Running")
        end

        status_message "Gathering run outputs and log"
        download_outputs(run)
        download_log(run)

        @run.outputs = process_outputs(run)
        @run.finish_time = run.finish_time
        @run.save

        run.delete
      rescue => exception
        begin
          unless run.nil?
            download_log(run)
            run.delete
          end
        rescue
          # Try and grab the log then delete the run from Taverna Server here,
          # but at this point we don't care if we fail...
        end

        unless TavernaPlayer.run_failed_callback.nil?
          status_message "Running post-failure tasks"
          callback(TavernaPlayer.run_failed_callback, @run)
        end

        backtrace = exception.backtrace.join("\n")
        @run.failure_message = "#{exception.message}\n#{backtrace}"

        @run.state = :failed
        @run.finish_time = Time.now
        status_message "Failed"
        return
      end

      unless TavernaPlayer.post_run_callback.nil?
        status_message "Running post-run tasks"
        callback(TavernaPlayer.post_run_callback, @run)
      end

      @run.state = :finished
      status_message "Finished"
    end

    private

    def download_log(run)
      Dir.mktmpdir(run.id, Rails.root.join("tmp")) do |tmp_dir|
        tmp_file_name = File.join(tmp_dir, "log.txt")
        begin
          run.log(tmp_file_name)
          @run.log = File.new(tmp_file_name)
          @run.save
        rescue T2Server::AttributeNotFoundError
          # We don't care if there's no log but we do want to catch the error!
        end
      end
    end

    def download_outputs(run)
      Dir.mktmpdir(run.id, Rails.root.join("tmp")) do |tmp_dir|
        tmp_file_name = File.join(tmp_dir, "all.zip")
        run.zip_output(tmp_file_name)
        @run.results = File.new(tmp_file_name)
        @run.save
      end
    end

    def process_outputs(run)
      outputs = []

      Dir.mktmpdir(run.id, Rails.root.join("tmp")) do |tmp_dir|
        run.output_ports.each_value do |port|
          output = TavernaPlayer::RunPort::Output.new(:name => port.name,
            :depth => port.depth)

          tmp_file_name = File.join(tmp_dir, port.name)

          if port.depth == 0
            if port.type =~ /text/
              output.value = read_file_from_zip(@run.results.path, port.name)
            else
              port_name = port.error? ? "#{port.name}.error" : port.name
              output.file = singleton_output(port_name, tmp_file_name)
            end
          else
            # TODO: Need to rework this so it's not just re-downloading the
            # whole port again. This is the quickest way right now though.
            port.zip("#{tmp_file_name}.zip")
            output.file = File.new("#{tmp_file_name}.zip")
          end

          # Set the output port size and type metadata.
          output.value_type = port.type
          output.value_size = port.size

          outputs << output
        end
      end

      outputs
    end

    def singleton_output(name, tmp_file)
      File.open(tmp_file, "wb") do |file|
        file.write read_file_from_zip(@run.results.path, name)
      end

      File.new(tmp_file)
    end

    def status_message(message)
      @run.status_message = message
      @run.save!
    end

    def cancelled?
      # Need to poll for updates as the run instance may have been
      # changed in the Rails app.
      @run.reload
      @run.stop
    end

    def cancel(run = nil)
      status_message "Cancelling"

      unless run.nil?
        download_log(run)
        run.delete
      end

      unless TavernaPlayer.run_cancelled_callback.nil?
        status_message "Running post-cancel tasks"
        callback(TavernaPlayer.run_cancelled_callback, @run)
      end

      @run.state = :cancelled
      @run.finish_time = Time.now
      status_message "Cancelled"
    end

  end
end
