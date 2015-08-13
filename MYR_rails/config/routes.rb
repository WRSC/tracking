Rails.application.routes.draw do
  # Default root

    root 'static_pages#home'  

  # Resources

    resources :coordinates
    resources :trackers
    resources :members do
      member do
        patch :invite
        patch :kick
        patch :leave
      end
    end
    resources :teams do
      member do
        patch :join
      end
    end
    resources :robots
    resources :attempts
    resources :missions
    resources :markers
    resources :sessions
    resources :scores 
   
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: [:new, :create, :edit, :update, :sent_password_reset_email]

  # GET

    get 'home'            , to: 'static_pages#home'
    get 'contact'         , to: 'static_pages#contact'
    get 'instructions'    , to: 'static_pages#instructions'
    get 'real-time'       , to: 'real_time#show'
    get 'replay'          , to: 'replay#show'
    get 'markersCreation' , to: 'admin_markers#show'
    
    
    get 'password_resets/sent_password_reset_email'
    get 'account_activations/wait_for_activated'


  # Ajax

    
    get  'gatherCoordsBetweenDates',  to: 'coordinates#gatherCoordsBetweenDates'
    get  'gatherCoordsSince'       ,  to: 'coordinates#gatherCoordsSince'
   	
   	get  'map_panel'               ,  to: 'real_time#map_panel' 
   	get  'getMissions'             ,  to: 'real_time#getMissions'
    get  'getNewTrackers'          ,  to: 'real_time#getNewTrackers'
    get  'update_map'              ,  to: 'real_time#update_map' 
    get  'options_panel'           ,  to: 'real_time#options_panel'
    get  'robots_panel'            ,  to: 'real_time#robots_panel'
    get  'update_map_auto'         ,  to: 'real_time#update_map_auto'
    get  'getMissionBuoys'         ,  to: 'real_time#getMissionBuoys'
    get  'trackerOfRobot'          ,  to: 'real_time#trackerOfRobot'
    get  'manageDispRobot'         ,  to: 'real_time#manageDispRobot'
    
    get  'choice_teams'            ,  to: 'replay#choice_teams'
    get  'choice_robots'           ,  to: 'replay#choice_robots'
    get  'choice_onerobot'         ,  to: 'replay#choice_onerobot'
    get  'choice_replay_missions'  ,  to: 'replay#choice_replay_missions'
    get  'choice_datetimes'        ,  to: 'replay#choice_datetimes'
    get  'choice_attempts'         ,  to: 'replay#choice_attempts'
    get  'update_replay_map'       ,  to: 'replay#update_replay_map'
    get  'choice_attempts'         ,  to: 'replay#choice_attempts'
    get  'getSingleAttemptInfos'   ,  to: 'replay#getSingleAttemptInfos'
    get  'getTrackersFromDatetimes',  to: 'replay#getTrackersFromDatetimes'
    get  'infowindow'              ,  to: 'replay#infowindow'
		get  'officialMarkersInfo'     ,  to: 'replay#officialMarkersInfo'


  # Authentication

    match '/signup' => 'members#new', :via => [:get]
    match '/signin' => 'sessions#new', :via => [:get]
    match '/signout' => 'sessions#delete', :via => [:get]
 
  #errors
  #get "/404", :to => "errors#not_found"
  #get "/422", :to => "errors#unacceptable"
  #get "/500", :to => "errors#internal_error"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
