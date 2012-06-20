Altereot::Application.routes.draw do
  
  match 'article/:id/tag/:tag_id/delete' => 'articles#tag_delete', :as => :article_tag_delete
  match 'reset_tgroup_selection' => 'articles#reset_tgroup_selection', :as => :reset_tgroup_selection
  match 'select_tgroup/:tgroup_id' => 'articles#select_tgroup', :as => :select_tgroup
  
  match 'comment_article/new.js/:parent_article' => 'comments#new', :as => :new_comment_article
  match 'comment_comment/new.js/:parent_comment' => 'comments#new', :as => :new_comment_comment
  resources :comments
  
  devise_scope :user do
    get 'login', :to => 'devise/sessions#new', :as => :login
    get 'logout', :to => 'devise/sessions#destroy', :as => :logout
    get 'register', :to => 'devise/registrations#new', :as => :register
    
  end
  
  devise_for :users#, :controllers => { :sessions => "users/sessions" }

  mount Ckeditor::Engine => '/ckeditor'

  resources :articles

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'articles#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
