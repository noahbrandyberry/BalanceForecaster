Rails.application.routes.draw do
  devise_for :users

  resources :accounts do
    resources :items
    get '/forecast', to: 'items#forecast', as: 'forecast'
  end

  root 'home#index'
end
