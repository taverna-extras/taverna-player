Rails.application.routes.draw do

  root :to => "home#index"

  resources :workflows, :only => :index do
    resources :runs, :controller => "TavernaPlayer::Runs", :except => [:edit, :update]
  end

  mount TavernaPlayer::Engine, :at => "/"
end
