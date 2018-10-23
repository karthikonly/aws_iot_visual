Rails.application.routes.draw do
  root 'home#activations'

  post '/api/configuration', to: 'configuration#get'
  get '/api/activations', to: 'activations#get'
  post '/api/activations', to: 'activations#create'
  put '/api/activations', to: 'activations#update'
  get '/api/devices', to: 'devices#get'

  resources :gateways, only: [:index]
  resources :ts_names, only: [:index]
  resources :series, only: [:index]
  resources :points, only: [:index]

end
