TavernaPlayer::Engine.routes.draw do
  resources :runs, :except => [:edit, :update] do
    get "output/:port(/*path)", :action => "output", :on => :member
  end
end
