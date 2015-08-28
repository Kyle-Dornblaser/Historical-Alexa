Rails.application.routes.draw do
  root 'home#index'
  # id and format specified to fix problem with using domain names as slugs
  resources :domains, only: [:index, :show, :create], id: /([^\/])+?/, format: /json|csv|xml|yaml/
  get '/compare/:id', format: /json|csv|xml|yaml/, to: 'domains#compare_with', as: 'compare_with', id: /([^\/])+?/
  get '/compare/:id/:id2', format: /json|csv|xml|yaml/, to: 'domains#compare', as: 'compare', id: /([^\/])+?/, id2: /([^\/])+?/
end