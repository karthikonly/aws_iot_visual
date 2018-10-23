Rails.application.routes.draw do
  get 'configuration/get'
  root 'home#index'

  resources :gateways, only: [:index]
  resources :ts_names, only: [:index]
  resources :series, only: [:index]
  resources :points, only: [:index]
  post '/api/configuration', to: 'configuration#get'
  
end
