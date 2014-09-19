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

TavernaPlayer::Engine.routes.draw do

  # Only add the Taverna Player Workflow route if the host app is actually
  # using it.
  if TavernaPlayer.workflow_proxy.class_const == TavernaPlayer::Workflow
    resources :workflows, :only => :index do
      resources :runs, :controller => :runs, :except => :edit
    end
  end

  resources :runs, :except => :edit do
    member do
      put "cancel", :action => "cancel"
      get "input/:port", :action => "input"
      get "output/:port(/*path)", :action => "output"

      scope "download" do
        get "log", :action => "download_log"
        get "results", :action => "download_results"
        get "input/:port", :action => "download_input"
        get "output/:port", :action => "download_output"
      end

      scope "interaction" do
        get ":serial", :action => "read_interaction"
        post ":serial", :action => "write_interaction"
      end
    end
  end

  scope TavernaPlayer.admin_scope do
    resources :service_credentials
    get "job_queue", :controller => :job_queue, :action => "index"
  end
end
