require_dependency "taverna_player/application_controller"

require "zip/zip"

module TavernaPlayer
  class RunsController < TavernaPlayer::ApplicationController
    # GET /runs
    # GET /runs.json
    def index
      @runs = Run.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @runs }
      end
    end

    # GET /runs/1
    # GET /runs/1.json
    def show
      @run = Run.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @run }
      end
    end

    # GET /runs/new
    # GET /runs/new.json
    def new
      @run = Run.new
      @workflow = TavernaPlayer.workflow_class.find(params[:workflow_id])

      model = TavernaPlayer::Parser.parse(@workflow.file)
      @inputs = model.inputs
      @inputs.each do |i|
        i[:model] = RunPort::Input.new(:name => i[:name], :value => i[:example])
        @run.inputs << i[:model]
      end

      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @run }
      end
    end

    # POST /runs
    # POST /runs.json
    def create
      @run = Run.new(params[:run])

      respond_to do |format|
        if @run.save
          worker = TavernaPlayer::Worker.new(@run)
          Delayed::Job.enqueue worker, :queue => "player"

          format.html { redirect_to @run, :notice => 'Run was successfully created.' }
          format.json { render :json => @run, :status => :created, :location => @run }
        else
          format.html { render :action => "new" }
          format.json { render :json => @run.errors, :status => :unprocessable_entity }
        end
      end
    end

    # DELETE /runs/1
    # DELETE /runs/1.json
    def destroy
      @run = Run.find(params[:id])
      @run.destroy

      respond_to do |format|
        format.html { redirect_to runs_url }
        format.json { head :no_content }
      end
    end

    # GET /runs/1/output/*
    def output
      path = []
      unless params[:path].nil?
        path = params[:path].split("/").map { |p| p.to_i }
      end

      # There can be only 1.
      output = RunPort::Output.where(:run_id => params[:id],
        :name => params[:port]).first

      # If there is no such output port or the path is the wrong depth then
      # return a 404.
      if output.nil? || path.length != output.depth
        raise ActionController::RoutingError.new('Not Found')
      end

      # A singleton should just return the value (if it's small enough) or the
      # file if it's bigger. If it's a value in the database then it'll always
      # be a text value.
      if output.depth == 0
        if output.file.blank?
          send_data output.value, :disposition => "inline",
            :type => "text/plain"
        else
          send_data File.read(output.file.path), :disposition => "inline",
            :type => output.file_content_type
        end
      else
        file = path.map { |p| p += 1 }.join("/")
        type = recurse_into_lists(output.metadata[:type], path)

        # If it's an error, then we need to further hack the file path and
        # content type.
        if type == "application/x-error"
          file += ".error"
          type = "text/plain"
        end

        Zip::ZipFile.open(output.file.path) do |zip|
          send_data zip.read("#{file}"), :type => type,
            :disposition => "inline"
        end
      end
    end

    private

    # This is here because of Taverna's infinitely deep output ports :-(
    def recurse_into_lists(list, indexes)
      return list if indexes.empty? || !list.is_a?(Array)
      i = indexes.shift
      return recurse_into_lists(list[i], indexes)
    end

  end
end
