TavernaPlayer::Engine.routes.draw do
  resources :runs, :except => [:edit, :update]
end
