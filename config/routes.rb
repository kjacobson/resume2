Resume2::Application.routes.draw do
  resources :resume_highlights

  resources :resume_jobs

  resources :softwares do
      resources :jobs
      resources :years
  end

  resources :skills do
      resources :jobs
      resources :years
      resources :highlights
  end
  resources :highlights do
      resources :jobs
      resources :skills
  end

  resources :disciplines do
      resources :jobs
      resources :skills
  end

  resources :jobs do
      resources :skills
      resources :job_skills
      resources :softwares
      resources :job_softwares
      resources :highlights
      resources :disciplines
  end

  resources :resumes

  resource :user_session
  resource :account, :controller => 'users'
  resources :users do
      resources :jobs
      resources :skills
      resources :job_skills
      resources :softwares
      resources :job_softwares
      resources :highlights
      resources :disciplines
      resources :years
      # everything but resumes should be private to owner
      resources :resumes do
          resources :jobs
          resources :skills
          resources :job_skills
          resources :softwares
          resources :job_softwares
          resources :highlights
          resources :disciplines
          resources :years
      end
  end

  resources :home

  root :to => 'home#index', :as => :homepage

  resources :users, :user_sessions
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
    
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
