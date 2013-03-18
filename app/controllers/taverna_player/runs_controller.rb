require_dependency "taverna_player/application_controller"

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
      
      puts
      puts
      p params[:run]
      puts
      puts
      
      @run = Run.new(params[:run])

      respond_to do |format|
        if @run.save
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

  end
end
