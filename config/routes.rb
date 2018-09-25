Rails.application.routes.draw do
  root 'home#index'

  resources :gateways, only: [:index]
  resources :ts_names, only: [:index]
  resources :series, only: [:index]
  resources :points, only: [:index]
end
