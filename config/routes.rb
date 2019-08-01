Rails.application.routes.draw do
  devise_for :users

  resources :accounts do
    resources :items
  end

  root 'home#index'
end
