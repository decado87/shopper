Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'categories#index'

  resources :categories, only: [:index] do
    resources :products, only: [:index]
  end

  get '/cart', to: 'order_items#index'
  resources :order_items, path: '/cart/items'

  get '/cart/checkout', to: 'orders#new', as: :checkout
  patch '/cart/checkout', to: 'orders#create'

  get '/order/find', to: 'orders#find', as: :find

  get '/order/:id', to: 'orders#order', as: :order
  resources :orders, only: [:index]

  post 'order/find_order', to: 'orders#redirect_order', as: :redirect_order

end
