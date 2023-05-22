Rails.application.routes.draw do
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: 'users/registrations'  }
  # home
  root 'home#index'
  get 'home/reset_password' => 'home#reset_password', as: 'reset_password'
  patch 'home/update_reset_password' => 'home#update_reset_password', as: 'send_reset_password'

  #dashboard
  get 'dashboard/index'
  get 'dashboard' => 'dashboard#index', as: 'dashboard'
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
  get 'addcards/edit_desc/:cb_id/:card_id/:id' => 'addcards#edit_desc', as: 'edit_desc'
  get 'addcomment/edit/:cb_id/:card_id/:id' => 'addcards#edit_comment', as: 'edit_comment'
  patch 'addcards/:cb_id/:card_id/:id' => 'addcards#update', as: 'update_addcard'
  patch 'attendance/:cb_id/:card_id/:id' => 'addcards#attendance', as: 'attendance'
  delete 'addcards/:cb_id/:card_id/:id' => 'addcards#destroy', as: 'delete_addcard'
  resources :addcards

  # addcomments
  post 'addcomments/:cb_id/:card_id/:id' => 'addcomments#create', as: 'create_addcomment'
  patch 'addcomments/:cb_id/:card_id/:id' => 'addcomments#update', as: 'update_addcomment'
  delete 'addcomments/:cb_id/:card_id/:id' => 'addcomments#destroy', as: 'delete_addcomment'

  # Edit User Account
  patch 'editaccounts' => 'editaccounts#update', as: 'update_account'

  # Profile pic
  post 'create/profilepic' => 'profilepics#create', as: 'create_pic'
  patch 'update/profilepic' => 'profilepics#update', as: 'update_pic'
  delete 'delete/profilepic' => 'profilepics#destroy', as: 'delete_pic'

  # All Users
  get 'allusers' => 'allusers#index', as: 'view_allusers'
  patch 'update/role/:id' => 'allusers#update', as: 'update_role'
  patch 'update/admin/:id/:admin' => 'allusers#updateadmin', as: 'update_admin'

  # Projects
  get 'projects' => 'projects#index', as: 'view_projects'
  # patch 'update/role/:id' => 'allusers#update', as: 'update_role'
  # patch 'update/admin/:id/:admin' => 'allusers#updateadmin', as: 'update_admin'

 # Rocks
  post 'create/rocks' => 'projects#create_rocks', as: 'create_rocks'
  patch 'update/rocks' => 'projects#update_rocks', as: 'update_rocks'
  delete 'delete/rocks/:id' => 'projects#delete_rocks', as: 'delete_rocks'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
