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

  resources :missions do
    member do
      get :latest_coordinates, to: "coordinates#latest_by_mission"
    end
  end

    resources :markers
    resources :sessions
    resources :scores
    resources :editions 
   
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: [:new, :create, :edit, :update, :sent_password_reset_email]

  # GET

    get 'home'            , to: 'static_pages#home'
    get 'contact'         , to: 'static_pages#contact'
    get 'instructions'    , to: 'static_pages#instructions'
    get 'real-time'       , to: 'real_time#show'
    get 'replay'          , to: 'replay#show'
    get 'markersCreation' , to: 'admin_markers#show'

    get 'map'             , to: 'markers#map'
    
  # score
		get 'triangular'      , to: 'scores#triangular'
    get 'areascanning'    , to: 'scores#areascanning' 
		get 'stationkeeping'  , to: 'scores#stationkeeping'
		get 'fleetrace'       , to: 'scores#fleetrace'
    
    get 'password_resets/sent_password_reset_email'
    get 'account_activations/wait_for_activated'

  # CSV

    get 'export', to: 'coordinates#export', as: :coordinates_export
    get 'export_attempt', to: 'attempts#export_attempt', as: :attempts_export

  # Ajax

    
    get  'gatherCoordsBetweenDates',  to: 'coordinates#gatherCoordsBetweenDates'
    get  'gatherCoordsLittleByLittle',  to: 'coordinates#gatherCoordsLittleByLittle'
    get  'gatherCoordsSince'       ,  to: 'coordinates#gatherCoordsSince'
   	
		get  'teamMembers'             ,  to: 'teams#teamMembers'
		get  'teamRobots'              ,  to: 'teams#teamRobots'
		get  'kick'                    ,  to: 'teams#kick'
	
		get  'pointinfo'               ,  to: 'markers#pointinfo'
    get  'missionMarkers'          ,  to: 'markers#getMissionMarkers'
    get  'mission_panel'           ,  to: 'markers#mission_panel'

		get  'robotChart'              ,  to: 'robots#robotChart'

		get  'uploadXMLAS'             ,  to: 'attempts#uploadXMLAS'
		post 'uploadXMLAS'             ,  to: 'attempts#updateXMLAS'
		get  'uploadJsonAS'            ,  to: 'attempts#uploadJsonAS'
		post 'uploadJsonAS'            ,  to: 'attempts#updateJsonAS'
		get  'generateXMLfile'         ,  to: 'attempts#generateXMLfile'
       

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
    get  'choice_editions'         ,  to: 'replay#choice_editions'
    get  'choice_robots'           ,  to: 'replay#choice_robots'
    get  'choice_onerobot'         ,  to: 'replay#choice_onerobot'
    get  'choice_replay_missions'  ,  to: 'replay#choice_replay_missions'
    get  'choice_datetimes'        ,  to: 'replay#choice_datetimes'
    get  'update_replay_map'       ,  to: 'replay#update_replay_map'
    get  'choice_attempts'         ,  to: 'replay#choice_attempts'
    get  'getSingleAttemptInfos'   ,  to: 'replay#getSingleAttemptInfos'
    get  'getTrackersFromDatetimes',  to: 'replay#getTrackersFromDatetimes'
    get  'infoAttempt'             ,  to: 'replay#infoAttempt'
		get  'officialMarkersInfo'     ,  to: 'replay#officialMarkersInfo'

		get  'newAttemptinfo'          ,  to: 'scores#newAttemptinfo'
		get  'newScoreinfo'            ,  to: 'scores#newScoreinfo'
		get  'calculateTimecost'       ,  to: 'scores#calculateTimecost'
		get  'calculateRawscore'       ,  to: 'scores#calculateRawscore'
#===================== triangular ====================================
		get  'triangularsailboat'      ,  to: 'scores#triangularsailboat'
	  get  'triangularmicrosailboat' ,  to: 'scores#triangularmicrosailboat'
#===================== station keeping ===============================
		get  'stationkeepingsailboat'  ,  to: 'scores#stationkeepingsailboat'
	  get  'stationkeepingmicrosailboat',  to: 'scores#stationkeepingmicrosailboat'
#===================== area scanning ==================================
		get  'areascanningsailboat'    ,  to: 'scores#areascanningsailboat'
	  get  'areascanningmicrosailboat',  to: 'scores#areascanningmicrosailboat'
#===================== fleet race =====================================
		get  'racesailboat'            ,  to: 'scores#racesailboat'
	  get  'racemicrosailboat'       ,  to: 'scores#racemicrosailboat'





  # Authentication

    match '/signup' => 'members#new', :via => [:get]
    match '/signin' => 'sessions#new', :via => [:get]
    match '/signout' => 'sessions#delete', :via => [:get]
 
    match '/404', to: 'errors#file_not_found', via: :all
    match '/422', to: 'errors#unprocessable', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all


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
