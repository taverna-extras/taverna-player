TavernaPlayer::Engine.routes.draw do
  resources :runs, :except => [:edit, :update] do
    get "output/:port(/*path)", :action => "output", :on => :member
    get "proxy/:name", :action => "read_interaction", :on => :member
    put "proxy/:name", :action => "save_interaction", :on => :member
    post "proxy", :action => "notification", :on => :member
  end
end
