
module TavernaPlayer
  module Concerns
    module Controllers
      module RunsController

        extend ActiveSupport::Concern

        included do
          before_filter :find_runs, :only => [ :index ]
          before_filter :find_run, :except => [ :index, :new, :create ]

          layout :choose_layout

          private

          def find_runs
            @runs = Run.all
          end

          def find_run
            @run = Run.find(params[:id])
          end

          # Read a resource from the interactions working directory of a run. If
          # it's an html resource then rewrite the links within it to point back to
          # this portal.
          #
          # This is a bit of a hack because we have to comply with Taverna Server's
          # security model.
          def proxy_read(name, type = :any)
            credentials = T2Server::HttpBasic.new(TavernaPlayer.server_username,
            TavernaPlayer.server_password)
            server = T2Server::Server.new(TavernaPlayer.server_address)
            uri = URI.parse("#{@run.proxy_interactions}/#{name}")

            page = server.read(uri, "*/*", credentials)

            if type == :html
              page.gsub!(@run.proxy_interactions, run_url(@run) + "/proxy")
              page.gsub!(@run.proxy_notifications, run_url(@run) + "/proxy")
            end

            page
          end

          # Write a resource to the interactions working directory of a run.
          #
          # This is a bit of a hack because we have to comply with Taverna Server's
          # security model.
          def proxy_write(name, data)
            credentials = T2Server::HttpBasic.new(TavernaPlayer.server_username,
            TavernaPlayer.server_password)
            server = T2Server::Server.new(TavernaPlayer.server_address)
            uri = URI.parse("#{@run.proxy_interactions}/#{name}")

            server.update(uri, data, "*/*", credentials)
          end

          # Publish an interaction reply to the run's notification feed.
          #
          # This is a bit of a hack because we have to comply with Taverna Server's
          # security model.
          def proxy_reply(data)
            credentials = T2Server::HttpBasic.new(TavernaPlayer.server_username,
            TavernaPlayer.server_password)
            server = T2Server::Server.new(TavernaPlayer.server_address)
            uri = URI.parse(@run.proxy_notifications)

            server.create(uri, data, "application/atom+xml", credentials)
          end

          # Read the data from the results zip file.
          def read_from_zip(file)
            Zip::ZipFile.open(@run.results.path) do |zip|
              zip.read(file)
            end
          end

          # This is here because of Taverna's infinitely deep output ports :-(
          def recurse_into_lists(list, indexes)
            return list if indexes.empty? || !list.is_a?(Array)
            i = indexes.shift
            return recurse_into_lists(list[i], indexes)
          end

          # Choose a layout for the page depending on action and embedded status.
          def choose_layout
            case action_name
            when "new", "show"
              @run.embedded? ? "taverna_player/embedded" : "application"
            else
            "application"
            end
          end

        end # included

        # GET /runs
        def index
          respond_to do |format|
            format.html # index.html.erb
          end
        end

        # GET /runs/1
        def show
          if @run.running?
            @interaction = Interaction.find_by_run_id_and_replied(@run.id, false)
            unless @interaction.nil?
              unless @interaction.displayed
                @new_interaction = true
                @interaction.displayed = true
                @interaction.save
              end
            end
          end

          respond_to do |format|
            # Render show.{html|js}.erb unless the run is embedded.
            format.html { render "taverna_player/runs/embedded/show" if @run.embedded }
            format.js { render "taverna_player/runs/embedded/show" if @run.embedded }
          end
        end

        # GET /runs/new
        def new
          @run = Run.new
          @workflow = TavernaPlayer.workflow_proxy.class_name.find(params[:workflow_id])
          @run.name = TavernaPlayer.workflow_proxy.title(@workflow)
          @run.embedded = true if params[:embedded] == "true"

          model = TavernaPlayer::Parser.parse(TavernaPlayer.workflow_proxy.file(@workflow))
          @inputs = model.inputs
          @inputs.each do |i|
            i[:model] = RunPort::Input.new(:name => i[:name], :value => i[:example])
            @run.inputs << i[:model]
          end

          respond_to do |format|
            # Render new.html.erb unless the run is embedded.
            format.html { render "taverna_player/runs/embedded/new" if @run.embedded }
          end
        end

        # POST /runs
        def create
          @run = Run.new(params[:run])

          respond_to do |format|
            if @run.save
              worker = TavernaPlayer::Worker.new(@run)
              Delayed::Job.enqueue worker, :queue => "player"

              format.html { redirect_to @run, :notice => 'Run was successfully created.' }
            else
              format.html { render :action => "new" }
            end
          end
        end

        # DELETE /runs/1
        def destroy
          if @run.finished? || @run.cancelled?
            @run.destroy
            redirect_to runs_url
          else
            redirect_to :back
          end
        end

        # PUT /runs/1/cancel
        def cancel
          @run.cancel unless @run.finished?

          if @run.embedded?
            redirect_to view_context.new_embedded_run_path(@run)
          else
            redirect_to :back
          end
        end

        # GET /runs/1/output/*
        def output
          # We need to parse out the path into a list of numbers here so we have
          # a list of indices into the file structure.
          path = []
          unless params[:path].nil?
            path = params[:path].split("/").map { |p| p.to_i }
          end

          output = RunPort::Output.find_by_run_id_and_name(@run.id, params[:port])

          # If there is no such output port or the path is the wrong depth then
          # return a 404.
          if output.nil? || path.length != output.depth
            raise ActionController::RoutingError.new('Not Found')
          end

          # A singleton should just return the value (if it's small enough) or the
          # file if it's bigger. If it's a value in the database then it'll always
          # be a text value, although not necessarily "plain".
          if output.depth == 0 && !output.value.blank?
            send_data output.value, :disposition => "inline",
              :type => output.metadata[:type]
          else
          # We need to rebuild the path indices into a string here (and can't
          # re-use the params[:path] variable directly) because files are
          # indexed from one in the zip we get back from Server, not zero.
            path_s = path.map { |p| p += 1 }.join("/")
            file = path_s.blank? ? "#{output.name}" : "#{output.name}/#{path_s}"
            type = recurse_into_lists(output.metadata[:type], path)

            # If it's an error, then we need to further hack the file path and
            # content type.
            if type == "application/x-error"
              file += ".error"
              type = "text/plain"
            end

            send_data read_from_zip(file), :type => type,
              :disposition => "inline"
          end
        end

        # GET /runs/1/interaction/:name
        def read_interaction
          respond_to do |format|
            name = "#{params[:name]}.#{params[:format]}"

            format.html do
              send_data proxy_read(name, :html), :type => "text/html",
                :disposition => "inline"
            end

            format.js do
              send_data proxy_read(name), :type => "text/javascript",
                :disposition => "inline"
            end

            format.json do
              send_data proxy_read(name),:type => "application/json",
                :disposition => "inline"
            end
          end
        end

        # PUT /runs/1/interaction/:name
        def save_interaction
          respond_to do |format|
            name = "#{params[:name]}.#{params[:format]}"

            format.json do
              proxy_write(name, request.body.read)
              render :nothing => true, :status => 204
            end
          end
        end

        # POST /runs/1/notification
        def notification
          proxy_reply(request.body.read)

          render :nothing => true, :status => 201
        end

      end
    end
  end
end
