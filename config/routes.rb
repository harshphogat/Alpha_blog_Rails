Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :articles
  root 'pages#test'
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  post 'follow', to: 'users#follow'
  delete 'unfollow', to: 'users#unfollow'
  resources :categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
