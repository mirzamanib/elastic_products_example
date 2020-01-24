Rails.application.routes.draw do
  root 'products#index'
  post '/', to: 'products#index'

  resources :products
  post 'products/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
