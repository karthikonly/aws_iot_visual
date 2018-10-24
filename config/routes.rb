Rails.application.routes.draw do
  root 'home#activations'
  get '/activations/new', to: 'home#new'
  post '/activations/create', to: 'home#create'
  get '/activations/:id', to: 'home#activation'

  post '/api/configuration', to: 'configuration#get'
  get '/api/activations', to: 'activations#get'
  post '/api/activations', to: 'activations#create'
  put '/api/activations/:id', to: 'activations#update'
  get '/api/activations/:id', to: 'activations#details'
  delete '/api/activations/:id', to: 'activations#delete'
  get '/api/devices', to: 'devices#get'
  post '/api/activations/:id/inventory', to: 'activations#inventory'
  post '/api/activations/:id/serial', to: 'activations#serial'
  delete '/api/activations/:id/serial', to: 'activations#delete_serial'

  get '/home/index', to: 'home#index'
  resources :gateways, only: [:index]
  resources :ts_names, only: [:index]
  resources :series, only: [:index]
  resources :points, only: [:index]

end
