TavernaPlayer::Engine.routes.draw do
  resources :runs, :except => [:edit, :update] do
    member do
      put "cancel", :action => "cancel"
      get "output/:port(/*path)", :action => "output"
      get "proxy/:int_id/:name", :action => "read_interaction"
      put "proxy/:int_id/:name", :action => "save_interaction"
      post "proxy/:int_id", :action => "notification"
    end
  end

  resources :service_credentials
end
