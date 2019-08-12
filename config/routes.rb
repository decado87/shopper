Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'products#index'

  get '/cart', to: 'order_items#index'
  resources :order_items, path: '/cart/items'

  get '/cart/checkout', to: 'orders#create', as: :checkout

  get '/order/find', to: 'orders#find', as: :find

  get '/order/:id', to: 'orders#order', as: :order
  resources :orders, only: [:index]

  post 'order/find_order', to: 'orders#redirect_order', as: :redirect_order

  # get '/', to: 'orders#remove_order', as: :remove_order

  post 'order/:id', to: 'orders#delete_order', as: :delete_order

end
