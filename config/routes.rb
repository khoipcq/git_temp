HelloWorld::Application.routes.draw do

  constraints(Subdomain) do
    match '/' => 'subdomain#index'
    match "/auth/sign_in", :to => "subdomain#login", :via => :get
    match "/auth/sign_up", :to => "subdomain#signup", :via => :get
    match "/my_page", :to => "subdomain#show", :via => :get
    match "/booking", :to => "subdomain#booking", :via => :get
    match "/auth/password/new", :to => "subdomain#forgot_password", :via => :get
  end
  
  get "reviews/index"

  get "billing_report/index"


  devise_for :users, :path => "auth",
  :controllers =>{passwords: "passwords", registrations: 'registrations'} do
    match "/thank_you_sign_up" => "registrations#thank_you_sign_up"
    match "/thank_you_password_reset" => "passwords#thank_you_password_reset"
    match "/changed_successfully" => "passwords#changed_successfully"
  end

  # devise_for :users, :path => "auth", :controllers =>{passwords: "passwords", registrations: 'registrations', sessions: 'sessions', confirmations: 'confirmations'} do
  #   # match "/thank_you_password_reset" => "passwords#thank_you_password_reset"
  #   # match "/changed_successfully" => "passwords#changed_successfully"
  #   match "/thank_you_sign_up" => "registrations#thank_you_sign_up"
  # end
  #unless Rails.application.config.consider_all_requests_local
  #match '*not_found', to: 'errors#error_404'
  #end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  #resources :pricing_plans
  resources :features do
    post "update_feature",:on =>:collection
    post "delete",:on =>:collection
    get "get_all_data", :on => :collection
    get "get_all_data_by_pricing_plan_id", :on => :collection
    post "update_order",:on =>:collection
  end
  resources :billing_reports do
    get "export"
  end



  resources :organizations do
    get "get_appointments"
    resources :users do
      get "reorder"
      post "update_profile", :on =>:collection
      post "update_profile_store_owner", :on =>:collection
      post "update_credit_card_store_owner", :on =>:collection
    end
    resources :locations
    
    resources :user_groups do
      get "get_available_user"
      get "add_user_to_group"
      get "update_permissions"

    end
    resources :activities
    resources :reviews
    resources :appointments do
      get "report", :on => :collection
    end
    resources :services
    resources :customers
    resources :staffs
    resources :email_campaigns
    resources :settings
  end

  resources :pricing_plans do
    post "delete",:on =>:collection
    post "update_pricing_plan",:on =>:collection
  end
  resources :store_owners do
    post "delete",:on =>:collection
    post "stop_access",:on =>:collection
  end

  get "home/index"
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  get 'thank_you_password_reset', :to => "passwords#thank_you_password_reset", :as => "thank_you"
  get 'changed_successfully', :to => "passwords#changed_successfully", :as => "updated_password"
end
