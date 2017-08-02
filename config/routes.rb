Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  root 'application#index'
  resources :projects do
    resources :tasks, only: [:create, :edit, :update, :destroy]
  end
  resources :tasks
end
