Rails.application.routes.draw do
  devise_for :users
  root 'application#index'
  resources :projects do
    resources :tasks, only: [:edit, :update, :destroy]
  end
  get '/tasks/overdue' => 'tasks#index_overdue', as: 'overdue_tasks'
  resources :tasks
end
