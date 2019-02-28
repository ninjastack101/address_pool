Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  devise_scope :user do
    root 'devise/sessions#new'
  end

  get '/my_address', to: 'users#my_address'
  resource :users, only:[] do
    post :assign_address, on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post 'users/sign_in', to: 'sessions#sign_in'
      post 'users/sign_out', to: 'sessions#sign_out'
      post 'users/assign_address', to: 'users#assign_address'
      post :my_address, to: 'users#my_address'
    end
  end
  match '*unmatched_route', to: 'application#not_found', via: :all
end
