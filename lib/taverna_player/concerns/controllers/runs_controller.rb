#------------------------------------------------------------------------------
# Copyright (c) 2013 The University of Manchester, UK.
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
  module Concerns
    module Controllers
      module RunsController

        extend ActiveSupport::Concern

        include TavernaPlayer::Concerns::Callback
        include TavernaPlayer::Concerns::Utils

        included do
          respond_to :html, :json, :js

          before_filter :find_runs, :only => [ :index ]
          before_filter :find_run, :except => [ :index, :new, :create ]
          before_filter :find_workflow, :only => [ :new ]
          before_filter :setup_new_run, :only => :new
          before_filter :set_run_user, :only => :create
          before_filter :filter_update_parameters, :only => :update
          before_filter :find_interaction, :only => [ :read_interaction, :write_interaction ]

          layout :choose_layout

          private

          def find_runs
            select = { :embedded => false }
            select[:workflow_id] = params[:workflow_id] if params[:workflow_id]
            @runs = Run.where(select).all
          end

          def find_run
            @run = Run.find(params[:id])
          end

          def find_workflow
            @workflow = TavernaPlayer.workflow_proxy.class_name.find(params[:workflow_id])
          end

          def setup_new_run
            @run = Run.new(:workflow_id => @workflow.id)
            @run.embedded = true if params[:embedded] == "true"
          end

          def set_run_user
            return if params[:run][:embedded] == "true" || TavernaPlayer.user_proxy.nil?

            unless TavernaPlayer.current_user_callback.blank?
              user = callback(TavernaPlayer.current_user_callback)
              params[:run][:user_id] = user.id unless user.nil?
            end
          end

          def filter_update_parameters
            name = params[:run][:name]
            @update_parameters = { :name => name } unless name.blank?
          end

          def find_interaction
            @interaction = Interaction.find_by_run_id_and_serial(@run.id, params[:serial])
          end

          # Download an input or output port as an "attachment" (i.e. not
          # "inline").
          def download_port
            port = RunPort.find_by_run_id_and_name(@run.id, params[:port])

            # If there is no such port port then return a 404.
            raise ActionController::RoutingError.new('Not Found') if port.nil?

            if port.file.blank?
              send_data port.value, :type => "text/plain",
                :filename => "#{@run.name}-#{port.name}.txt"
            else
              send_file port.file.path, :type => port.file.content_type,
                :filename => "#{@run.name}-#{port.file_file_name}"
            end
          end

          # Read the data from the results zip file.
          def read_from_zip(file)
            Zip::ZipFile.open(@run.results.path) do |zip|
              zip.read(file)
            end
          end

          # Choose a layout for the page depending on action and embedded status.
          def choose_layout
            if (action_name == "new" || action_name == "show") && @run.embedded?
              "taverna_player/embedded"
            else
              ApplicationController.new.send(:_layout).virtual_path
            end
          end

        end # included

        # GET /runs
        def index

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

          respond_with(@run) do |format|
            # Render show.{html|js}.erb unless the run is embedded.
            format.any(:html, :js) do
              render "taverna_player/runs/embedded/show" if @run.embedded
            end
          end
        end

        # GET /runs/new
        def new
          respond_with(@run) do |format|
            # Render new.html.erb unless the run is embedded.
            format.html do
              render "taverna_player/runs/embedded/new" if @run.embedded
            end
          end
        end

        # POST /runs
        def create
          @run = Run.new(params[:run])
          if @run.save
            flash[:notice] = "Run was successfully created."
          end

          respond_with(@run, :status => :created, :location => @run)
        end

        # PUT /runs/1
        def update
          @run.update_attributes(@update_parameters)

          respond_with(@run)
        end

        # DELETE /runs/1
        def destroy
          if @run.destroy
            flash[:notice] = "Run was deleted."
            respond_with(@run)
          else
            flash[:error] = "Run must be cancelled before deletion."
            respond_with(@run, :nothing => true, :status => :forbidden) do |format|
              format.html { redirect_to :back }
            end
          end
        end

        # PUT /runs/1/cancel
        def cancel
          @run.cancel unless @run.complete?

          respond_with(@run, :action => :show) do |format|
            format.html do
              if @run.embedded?
                redirect_to view_context.new_embedded_run_path(@run)
              else
                redirect_to :back
              end
            end
          end
        end

        # GET /runs/1/download/log
        def download_log
          send_file @run.log.path, :type => "text/plain",
            :filename => "#{@run.name}-log.txt"
        end

        # GET /runs/1/download/results
        def download_results
          send_file @run.results.path, :type => "application/zip",
            :filename => "#{@run.name}-all-results.zip"
        end

        # GET /runs/1/download/output/:port
        def download_output
          download_port
        end

        # GET /runs/1/input/*
        def input
          input = RunPort::Input.find_by_run_id_and_name(@run.id, params[:port])

          # If there is no such input port then return a 404.
          raise ActionController::RoutingError.new('Not Found') if input.nil?

          if input.file.blank?
            send_data input.value, :disposition => "inline"
          else
            send_file input.file.path, :disposition => "inline"
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

        # GET /runs/1/interaction/:int_id
        def read_interaction
          send_data @interaction.page, :type => "text/html",
            :disposition => "inline"
        end

        # POST /runs/1/interaction/:int_id
        def write_interaction
          @interaction.data = request.body.read
          @interaction.feed_reply = request.headers["X-Taverna-Interaction-Reply"]
          @interaction.save

          render :nothing => true, :status => 201
        end

      end
    end
  end
end
