require "tmpdir"

module TavernaPlayer
  class Worker

    # Constants until we decide how to manage server instances
    SERVER_URI = URI.parse("http://localhost:8080/taverna242")
    USER_CREDS = T2Server::HttpBasic.new("taverna", "taverna")
    SERVER_POLL = 10

    def initialize(run)
      @run = run
      @workflow = Workflow.find(@run.workflow_id)
    end

    def perform
      status_message "Connecting to Taverna Server"
      T2Server::Server.new(SERVER_URI) do |server|
        status_message "Creating new workflow run"

        wkf = File.read(@workflow.file)

        server.create_run(wkf, USER_CREDS) do |run|
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
            sleep(SERVER_POLL)
            status_message @run.status_message + "."
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

      Dir.mktmpdir(@run.run_id, Rails.root.join("tmp")) do |tmp_dir|
        run.output_ports.each_value do |port|
          output = TavernaPlayer::RunPort::Output.new(:name => port.name, :depth => port.depth)

          tmp_file_name = File.join(tmp_dir, port.name)

          if port.depth == 0
            if port.size < 255
              output.value = port.value
            else
              port.write_value_to_file(tmp_file_name)
              output.file = File.new(tmp_file_name)
            end
          else
            port.zip(tmp_file_name)
            output.file = File.new(tmp_file_name)
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
