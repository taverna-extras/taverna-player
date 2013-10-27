TavernaPlayer::Engine.routes.draw do
  resources :runs, :except => :edit do
    member do
      put "cancel", :action => "cancel"
      get "output/:port(/*path)", :action => "output"
      get "proxy/:int_id/:name", :action => "read_interaction"
      put "proxy/:int_id/:name", :action => "save_interaction"
      post "proxy/:int_id", :action => "notification"
    end
  end

  resources :service_credentials

  if TavernaPlayer.enable_server_admin
    scope TavernaPlayer.server_admin_namespace do
      get "taverna", :controller => "taverna", :action => "index"
      put "taverna", :controller => "taverna", :action => "update"
    end
  end
end
