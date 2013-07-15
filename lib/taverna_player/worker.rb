module TavernaPlayer
  class Worker

    def initialize(run)
      @run = run
      @workflow = Workflow.find(@run.workflow_id)
    end

    def perform
      status_message "Connecting to Taverna Server"

      server_uri = URI.parse(TavernaPlayer.server_address)
      credentials = T2Server::HttpBasic.new(TavernaPlayer.server_username,
        TavernaPlayer.server_password)

      T2Server::Server.new(server_uri) do |server|
        status_message "Creating new workflow run"

        wkf = File.read(@workflow.file)

        server.create_run(wkf, credentials) do |run|
          @run.run_id = run.id
          @run.state = run.status
          @run.create_time = run.create_time
          @run.save

          unless @run.inputs.size == 0
            status_message "Uploading run inputs"
            @run.inputs.each do |input|
              if input.value.blank? && !input.file.blank?
                run.input_port(input.name).file = input.file.path
              else
                run.input_port(input.name).value = input.value
              end
            end
          end

          status_message "Starting run"
          run.start
          @run.state = run.status
          @run.start_time = run.start_time
          @run.save

          status_message "Running"
          until run.finished?
            sleep(TavernaPlayer.server_poll_interval)
            waiting = false

            run.notifications(:requests).each do |note|
              uri = note.uri.to_s
              waiting = true unless note.has_reply?
              int = Interaction.find_or_create_by_uri_and_run_id(uri, @run.id)

              if note.has_reply?
                int.replied = true
                int.save
              end
            end

            status_message(waiting ? "Waiting for user input" : "Running")
          end

          status_message "Gathering run outputs"
          @run.state = run.status
          @run.finish_time = run.finish_time

          @run.outputs = collect_outputs(run)
          @run.save

          run.delete
          status_message "Finished"
        end
      end
    end

    private

    def collect_outputs(run)
      outputs = []

      Dir.mktmpdir(run.id, Rails.root.join("tmp")) do |tmp_dir|
        tmp_file_name = File.join(tmp_dir, "all.zip")
        run.zip_output(tmp_file_name)
        @run.results = File.new(tmp_file_name)

        run.output_ports.each_value do |port|
          output = TavernaPlayer::RunPort::Output.new(:name => port.name,
            :depth => port.depth)

          if port.depth == 0 && port.type =~ /text/
            if port.size < 255
              output.value = port.value
            else
              output.value = port.value(0..255)
            end
          end

          output.metadata = {
            :size => port.size,
            :type => port.type
          }

          outputs << output
        end
      end

      outputs
    end

    def status_message(message)
      @run.status_message = message
      @run.save!
    end

  end
end
