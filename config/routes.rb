HelloWorld::Application.routes.draw do



  get "reviews/index"

  get "billing_report/index"


  devise_for :users, :path => "auth",
  :controllers =>{passwords: "passwords", registrations: 'registrations'} do
    match "/thank_you_sign_up" => "registrations#thank_you_sign_up"
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

  resources :pricing_plans
  resources :features
  resources :billing_reports
  


  resources :organizations do
    resources :users do
      get "reorder"
      post "update_profile",:on =>:collection
    end
    resources :locations
    resources :services
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
    resources :customers
    resources :staffs
  end

  constraints(Subdomain) do
    match '/' => 'organizations#show'
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
end
