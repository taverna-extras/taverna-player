TavernaPlayer::Engine.routes.draw do
  resources :runs, :except => :edit do
    member do
      put "cancel", :action => "cancel"
      get "input/:port", :action => "input"
      get "output/:port(/*path)", :action => "output"

      scope "download" do
        get "log", :action => "download_log"
        get "results", :action => "download_results"
        get "output/:port", :action => "download_output"
      end

      scope "interaction" do
        get ":int_id", :action => "read_interaction"
        post ":int_id", :action => "write_interaction"
      end
    end
  end

  resources :service_credentials
end
