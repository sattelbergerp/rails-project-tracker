Rails.application.routes.draw do
  devise_for :users
  root 'application#index'
  resources :projects
  get '/tasks/overdue' => 'tasks#index_overdue', as: 'overdue_tasks'
  resources :tasks
end
