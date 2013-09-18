TavernaPlayer::Engine.routes.draw do
  resources :runs, :except => [:edit, :update] do
    member do
      put "cancel", :action => "cancel"
      get "output/:port(/*path)", :action => "output"
      get "proxy/:name", :action => "read_interaction"
      put "proxy/:name", :action => "save_interaction"
      post "proxy", :action => "notification"
    end
  end

  resources :service_credentials
end
