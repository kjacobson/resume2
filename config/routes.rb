Resume2::Application.routes.draw do
  namespace :trends do
    resources :disciplines
    resources :jobs
    resources :links
    resources :skills
    resources :softwares
    resources :resumes
    resources :years
  end

  namespace :admin do
    resources :disciplines
    resources :highlights
    resources :jobs
    resources :job_skills, :as => :j_skills
    resources :job_softwares, :as => :j_softwares
    resources :links
    resources :skills
    resources :softwares
    resources :resumes
    resources :resume_highlights, :as => :r_highlights
    resources :resume_jobs, :as => :r_jobs
    resources :users
    resources :user_softwares, :as => :u_softwares
    resources :user_skills, :as => :u_skills
  end

  # non-admin and non-trends routes will always require a user
  # if a user is viewing any page belonging to a user other than the one he is logged in as,
  # routes will require user AND resume
  scope "users/:user_id" do
    resources :disciplines do
      get :confirm_delete, :on => :member
      resources :skills, :only => :index
      resources :jobs, :only => :index
    end
    resources :jobs do
      get :confirm_delete, :on => :member
    end
    resources :highlights do
      get :confirm_delete, :on => :member
    end
    resources :resumes do
      get :confirm_delete, :on => :member
    end
    resources :skills do
      get :confirm_delete, :on => :member
    end
    resources :softwares do
      get :confirm_delete, :on => :member
    end

    scope "(resumes/:resume_id)", :as => "resume" do
      resources :disciplines, :only => [:index, :show] do
        resources :skills, :only => :index
        resources :jobs, :only => :index
      end

      resources :highlights
      resources :links, :except => [:show] do
        get :confirm_delete, :on => :member
      end

      resources :jobs do
        resources :skills, :only => [:index, :new, :edit]
        resources :softwares, :only => [:index, :new, :edit]
        resources :highlights, :only => [:index, :new, :edit]
      end

      resources :skills, :except => ["edit", "update"] do
        resources :jobs, :only => :index
        resources :highlights, :only => :index
        resources :years, :only => :index
      end

      resources :softwares, :except => ["edit", "update"] do
        resources :jobs, :only => :index
        resources :years, :only => :index
      end

      resources :years, :only => [:index, :show] do
        resources :jobs, :only => :index
        resources :skills, :only => :index
        resources :softwares, :only => :index
      end
    end

    resources :job_skills, :as => :j_skills

    resources :job_softwares, :as => :j_softwares

    resources :resume_highlights, :as => :r_highlights do
      get :confirm_delete, :on => :member
    end

    resources :resume_jobs, :as => :r_jobs do
      get :confirm_delete, :on => :member
    end

    resources :user_skills, :as => :u_skills, :only => [:create, :update, :destroy]

    resources :user_softwares, :as => :u_softwares, :only => [:create, :update, :destroy]
  end

  resources :users do
    get :confirm_delete, :on => :member
  end
  resource :user_session
  resource :account, :controller => 'users'

  resources :home, :only => :index

  root :to => 'home#index', :as => :homepage

  resources :users, :user_sessions
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'signup' => 'users#new', :as => :signup
  match '/users/:user_id/account' => 'users#edit', :as => :account
    
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
