Rails.application.routes.draw do
  devise_for :users
  root 'application#index'
  resources :projects
  resources :tasks
end
