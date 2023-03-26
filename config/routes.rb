Rails.application.routes.draw do
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: 'users/registrations'  }

  #dashboard
  get 'dashboard/index'
  get 'dashboard' => 'dashboard#index', as: 'dashboard'
  root 'home#index'
  #create_board
  get 'showboard/:id/:from' => 'create_boards#show', as: 'show_board'
  patch	'create_boards/:id' => 'create_boards#update', as: 'update_board'
  delete 'create_boards/:id' => 'create_boards#destroy', as: 'delete_board'
  patch 'update_group/:id/:group' => 'create_boards#update_group', as: 'update_group'
  resources :create_boards

  #cards
  get 'cards/:cb_id' => 'cards#index', as: 'view_cards'
  get 'newcard/:cb_id' => 'cards#new', as: 'new_card'
  post 'cards/:cb_id' => 'cards#create', as: 'create_card'
  get 'card/:cb_id/:card_id/edit' => 'cards#edit', as: 'edit_card'
  patch 'card/:cb_id/:card_id' => 'cards#update', as: 'update_card'
  delete 'card/:cb_id/:card_id' => 'cards#destroy', as: 'delete_card'
  resources :cards
  # addcards
  get 'addcards/view/:cb_id/:card_id/:id' => 'addcards#index', as: 'view_addcards'
  get 'newcard/:cb_id/:card_id' => 'addcards#new', as: 'newcard'
  post 'addcards/:cb_id/:card_id' => 'addcards#create', as: 'create_addcard'
  get 'addcards/edit/:cb_id/:card_id/:id' => 'addcards#edit', as: 'edit_addcard'
  patch 'addcards/:cb_id/:card_id/:id' => 'addcards#update', as: 'update_addcard'
  delete 'addcards/:cb_id/:card_id/:id' => 'addcards#destroy', as: 'delete_addcard'
  resources :addcards
 

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
