Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  root 'application#index'
  resources :projects do
    resources :tasks, only: [:create, :edit, :update, :destroy]
  end
  get '/tasks/overdue' => 'tasks#index_overdue', as: 'overdue_tasks'
  resources :tasks
end
