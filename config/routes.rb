Rails.application.routes.draw do
  root 'home#activations'
  get '/activations/:id', to: 'home#activation'

  post '/api/configuration', to: 'configuration#get'

  resources :gateways, only: [:index]
  resources :ts_names, only: [:index]
  resources :series, only: [:index]
  resources :points, only: [:index]

end
