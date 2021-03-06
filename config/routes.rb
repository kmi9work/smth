Altereot::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

=begin
  match 'article/:id/criterion/:criterion_id/delete' => 'articles#criterion_delete', :as => :article_criterion_delete
  
  match 'date_sort/:date_type(/:order_by)' => 'articles#date_sort', :as => :date_sort
  match 'criterion_choose/:criterion_id' => 'articles#criterion_choose', :as => :criterion_choose
  match 'reset_filter_selection' => 'articles#reset_filter_selection', :as => :reset_filter_selection
  match 'select_filter/:filter_id(.:format)' => 'articles#select_filter', :as => :select_filter
  match 'filter_sort/:index/:order_by' => 'articles#filter_sort', :as => :filter_sort
  match 'delete_filter_selection/:index' => 'articles#delete_filter_selection', :as => :delete_filter_selection ###???
  
  match 'add_criterion/:num' => 'articles#add_criterion', :as => :add_criterion
  
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

  resources :articles do
    collection do
      get 'search'
      post 'update_search'
    end
  end
  
  match 'criterions/:filter_id/autocomplete' => 'criterions#autocomplete'
  
=end
  #DMP-----------------------------------
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :dmp_admins
  match 'dmp' => 'dmp#index', :as => :dmp
  match 'dmp/show/:id' => 'dmp#show', :as => :dmp_show
  match 'dmp/show_vkusers/:id' => 'dmp#show_vkusers', :as => :dmp_show_vkusers
  match 'dmp/new' => 'dmp#new', :as => :dmp_new
  match 'dmp/edit/:id' => 'dmp#edit', :as => :dmp_edit
  match 'dmp/create' => 'dmp#create', :as => :dmp_create
  match 'dmp/update/:id' => 'dmp#update', :as => :dmp_update
  match 'dmp/destroy/:id' => 'dmp#destroy', :as => :dmp_destroy
  
  # match 'country_ok_ajax' => 'dmp#country_ok_ajax', :as => :country_ok_ajax
  #   match 'city_ok_ajax' => 'dmp#city_ok_ajax', :as => :city_ok_ajax
  #   match 'school_ok_ajax' => 'dmp#school_ok_ajax', :as => :school_ok_ajax
  #   match 'university_ok_ajax' => 'dmp#university_ok_ajax', :as => :university_ok_ajax
  match 'vkuser_sent' => 'dmp#vkuser_sent'
  
  match 'country_autocomplete' => 'dmp#country_autocomplete', :as => :country_autocomplete
  match 'city_autocomplete(/:country)' => 'dmp#city_autocomplete', :as => :city_autocomplete
  match 'school_autocomplete(/:city)' => 'dmp#school_autocomplete', :as => :school_autocomplete
  match 'university_autocomplete(/:country/:city)' => 'dmp#university_autocomplete', :as => :university_autocomplete
  #DMP===================================


  root :to => 'dmp#index'

end
