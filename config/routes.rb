Rails.application.routes.draw do
  root 'home#activations'
  get '/activations/new', to: 'home#new'
  post '/activations/create', to: 'home#create'
  get '/activations/:id', to: 'home#activation'

  post '/api/configuration', to: 'configuration#get'
  get '/api/activations', to: 'activations#get'
  post '/api/activations', to: 'activations#create'
  put '/api/activations', to: 'activations#update'
  get '/api/activations/:id', to: 'activations#details'
  get '/api/devices', to: 'devices#get'

  get '/home/index', to: 'home#index'
  resources :gateways, only: [:index]
  resources :ts_names, only: [:index]
  resources :series, only: [:index]
  resources :points, only: [:index]

end
