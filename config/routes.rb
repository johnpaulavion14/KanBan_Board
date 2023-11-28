Rails.application.routes.draw do
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions", registrations: 'users/registrations'  }
  # home
  root 'home#index'
  get 'home/reset_password' => 'home#reset_password', as: 'reset_password'
  patch 'home/update_reset_password' => 'home#update_reset_password', as: 'send_reset_password'

  #dashboard
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
  patch 'update_conclusion/:cb_id/:card_id/:id' => 'addcards#update_conclusion', as: 'update_conclusion'
  post 'generate_mom/:cb_id/:card_id/:id' => 'addcards#generate_mom', as: 'generate_mom'
  delete 'addcards/:cb_id/:card_id/:id' => 'addcards#destroy', as: 'delete_addcard'
  resources :addcards
  # todo section
  post 'todo/:cb_id/:card_id/:id' => 'addcards#create_todo', as: 'create_todo'
  delete 'todo/:cb_id/:card_id/:id' => 'addcards#delete_todo', as: 'delete_todo'
  patch 'updatetodo/:cb_id/:card_id/:id' => 'addcards#update_todo', as: 'update_todo'
  patch 'updatecheckbox/:cb_id/:card_id/:id' => 'addcards#update_checkbox', as: 'update_checkbox'
  # identify section
  post 'identify/:cb_id/:card_id/:id' => 'addcards#create_identify', as: 'create_identify'
  delete 'identify/:cb_id/:card_id/:id' => 'addcards#delete_identify', as: 'delete_identify'
  patch 'updateidentify/:cb_id/:card_id/:id' => 'addcards#update_identify', as: 'update_identify'
  patch 'updateidentify_checkbox/:cb_id/:card_id/:id' => 'addcards#update_identify_checkbox', as: 'update_identify_checkbox'

  # addcomments``
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

  # Project Management Monitoring System Section
  # Projects
  get 'projects/dashboard' => 'projects#dashboard', as: 'projects_dashboard'
  get 'yourprojects/:pw_id/:rocks_owner' => 'projects#index', as: 'view_projects'
  get 'allprojects/:pw_id/:rocks_owner' => 'projects#allprojects', as: 'view_allprojects'

  # Workspace
  post 'create/workspace' => 'project_workspaces#create_workspace', as: 'create_workspace'
  patch 'update/workspace' => 'project_workspaces#update_workspace', as: 'update_workspace'
  delete 'delete/workspace/:id' => 'project_workspaces#delete_workspace', as: 'delete_workspace'

 # Rocks
  post 'create/rocks/:pw_id/:rocks_owner' => 'projects#create_rocks', as: 'create_rocks'
  patch 'update/rocks/:pw_id/:rocks_owner' => 'projects#update_rocks', as: 'update_rocks'
  # patch 'update/rocks_automate' => 'projects#automate_rocks', as: 'automate_rocks'
  patch 'update/rocks_reviewed_by/:pw_id/:rocks_owner' => 'projects#update_rocks_reviewedby', as: 'update_rocks_reviewedby'
  delete 'delete/rocks/:pw_id/:id/:rocks_owner' => 'projects#delete_rocks', as: 'delete_rocks'

  #Rock messages
  post 'projects/rockmessages/:pw_id/:rock_id/:rocks_owner' => 'projects#create_rockmessage', as: 'create_rockmessage'
  patch 'projects/rockmessages/:pw_id/:rock_id/:id/:rocks_owner' => 'projects#update_rockmessage', as: 'update_rockmessage'
  delete 'delete/rockmessages/:pw_id/:rock_id/:id/:rocks_owner' => 'projects#delete_rockmessage', as: 'delete_rockmessage'

  # Milestones
  post 'create/milestones/:pw_id/:rock_id/:rocks_owner' => 'projects#create_milestones', as: 'create_milestones'
  patch 'update/milestones/:pw_id/:rocks_owner' => 'projects#update_milestones', as: 'update_milestones'
  delete 'delete/milestones/:pw_id/:rock_id/:id/:rocks_owner' => 'projects#delete_milestones', as: 'delete_milestones'

  #Milestone messages
  post 'projects/messages/:pw_id/:milestone_id/:rocks_owner' => 'projects#create_message', as: 'create_message'
  patch 'projects/messages/:pw_id/:milestone_id/:id/:rocks_owner' => 'projects#update_message', as: 'update_message'
  delete 'delete/messages/:pw_id/:rock_id/:milestone_id/:id/:rocks_owner' => 'projects#delete_message', as: 'delete_message'

  # Sub Milestones
  post 'create/submilestones/:pw_id/:rock_id/:milestone_id/:rocks_owner' => 'submilestones#create_submilestones', as: 'create_submilestones'
  patch 'update/submilestones/:pw_id/:rocks_owner' => 'submilestones#update_submilestones', as: 'update_submilestones'
  delete 'delete/submilestones/:pw_id/:rock_id/:milestone_id/:id/:rocks_owner' => 'submilestones#delete_submilestones', as: 'delete_submilestones'

  # Sub Milestone messages
  post 'submilestones/submessages/:pw_id/:milestone_id/:submilestone_id/:rocks_owner' => 'submilestones#create_submessage', as: 'create_submessage'
  patch 'submilestones/submessages/:pw_id/:rock_id/:milestone_id/:submilestone_id/:id/:rocks_owner' => 'submilestones#update_submessage', as: 'update_submessage'
  delete 'delete/submessages/:pw_id/:rock_id/:milestone_id/:submilestone_id/:id/:rocks_owner' => 'submilestones#delete_submessage', as: 'delete_submessage'

  # Sub2milestones
  post 'create/sub2milestones/:pw_id/:rock_id/:milestone_id/:submilestone_id/:rocks_owner' => 'sub2milestones#create_sub2milestones', as: 'create_sub2milestones'
  patch 'update/sub2milestones/:pw_id/:rocks_owner' => 'sub2milestones#update_sub2milestones', as: 'update_sub2milestones'
  delete 'delete/sub2milestones/:pw_id/:rock_id/:milestone_id/:submilestone_id/:id/:rocks_owner' => 'sub2milestones#delete_sub2milestones', as: 'delete_sub2milestones'

  # Sub2milestone messages
  post 'sub2milestones/sub2messages/:pw_id/:milestone_id/:submilestone_id/:rocks_owner' => 'sub2milestones#create_sub2message', as: 'create_sub2message'
  patch 'sub2milestones/sub2messages/:pw_id/:rock_id/:milestone_id/:submilestone_id/:id/:rocks_owner' => 'sub2milestones#update_sub2message', as: 'update_sub2message'
  delete 'delete/sub2messages/:pw_id/:rock_id/:milestone_id/:submilestone_id/:id/:rocks_owner' => 'sub2milestones#delete_sub2message', as: 'delete_sub2message'

  # Gantt Section
  get 'gantt/index' => 'gantt#index', as: 'gantt'
  post 'gantt/update_gantt' => 'gantt#update_gantt', as: 'update_gantt'

  scope '/api' do
    get "/data", :to => "gantt#data"
    
    post "/task", :to => "task#add"
    put "/task/:id", :to => "task#update"
    delete "/task/:id", :to => "task#delete"

    post "/link", :to => "link#add"
    put "/link/:id", :to => "link#update"
    delete "/link/:id", :to => "link#delete"
  end


end
