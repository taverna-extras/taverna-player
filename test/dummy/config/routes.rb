Rails.application.routes.draw do

  resources :workflows, :only => :index

  mount TavernaPlayer::Engine => "/"
end
