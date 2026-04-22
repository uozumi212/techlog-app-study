Rails.application.routes.draw do
  devise_for :users
  root "home#top"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    collection do
      post :preview
    end
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :users, only: [:show]
end
