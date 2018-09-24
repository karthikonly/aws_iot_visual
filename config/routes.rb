Rails.application.routes.draw do
  # set homepage
  root 'home#index'

  get 'home/index'
end
