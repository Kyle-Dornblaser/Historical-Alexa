Rails.application.routes.draw do
  root 'home#index'
  # id and format specified to fix problem with using domain names as slugs
  resources :domains, only: [:index, :show, :create], id: /([^\/])+?/, format: /json|csv|xml|yaml/
end