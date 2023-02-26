Rails.application.routes.draw do
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: 'users/registrations'  }

  #Card
  post 'card/create' => 'cards#create', as: 'create_card'
  
  #add Addcard
  post 'addcards/:card_id/addcards' => 'addcards#create', as: 'create_addcard'
  get 'card/:card_id/:addcard_id/edit' => 'addcards#edit', as: 'edit_addcard'
  patch 'card/:card_id/addcards/:addcard_id' => 'addcards#update', as: 'update_addcard'
  get 'newcard/:id/:card_title' => 'addcards#new', as: 'newcard'
  delete 'card/:card_id/addcards/:addcard_id' => 'addcards#destroy', as: 'delete_addcard'

  resources :addcards
  resources :cards

  get 'dashboard/index'
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
