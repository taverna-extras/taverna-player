Rails.application.routes.draw do

  root :to => "home#index"

  resources :workflows, :only => :index

  mount TavernaPlayer::Engine, :at => "/"
end
