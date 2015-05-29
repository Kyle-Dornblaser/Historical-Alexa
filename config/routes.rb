Rails.application.routes.draw do
  root 'home#index'
  resources :domains, only: [:index, :show, :create]
end