Rails.application.routes.draw do
  get "users/show"
  devise_for :users
  root "home#top"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts, only: [:index, :new, :create, :show, :destroy]
  resources :users, only: [:show]
end
