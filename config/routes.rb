Rails.application.routes.draw do
  resources :cards
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: 'users/registrations'  }
  get 'dashboard/index'


  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
