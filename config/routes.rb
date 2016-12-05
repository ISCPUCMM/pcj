Rails.application.routes.draw do
  get 'sessions/new'

  mount Tasks::API => '/'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'

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

  resources :users  do
    get 'administration', on: :member
    get 'connections', on: :member

    namespace :student_portal do
      resources :courses, only: [:index] do
        resources :assignments, only: [:index] do
          get 'submissions'

          resources :problems, only: [:index, :show] do
            get 'assignment_start_countdown', on: :collection, as: :asc
          end
        end
      end
    end

    namespace :professor_portal do
      resources :courses, only: [:index] do
        resources :assignments, only: [:index] do
          get 'student_solutions'
          get 'student_statistics'
        end
      end
    end
  end

  namespace :student_portal do
    resources :submissions, only: [:show]

    resources :problem_solutions, only: [] do
      post 'submit', on: :member
      patch 'save_code', on: :member
      post 'test', on: :member
      post 'user_solutions', on: :collection
    end
  end

  resources :courses, except: [:index] do
    post 'add_student', on: :member
    post 'add_students', on: :member
    delete 'remove_student', on: :member
    post 'add_assignment', on: :member
    delete 'remove_assignment', on: :member
  end

  resources :assignments do
    post 'add_problem', on: :member
    delete 'remove_problem', on: :member
  end

  resources :problems do
    put 'upload_input_files', on: :member
    post 'generate_outputs', on: :member
    patch 'group_test_cases', on: :member
    patch 'group_individual_test_cases', on: :member
    delete 'ungroup_test_cases', on: :member
    post 'polygon_create', on: :collection
  end

  resources :test_cases, only: [] do
    get 'show_input_file', on: :member
    get 'show_output_file', on: :member
  end

  get '/users/:connection_token/connect', to: 'users#connect', as: :user_connect

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
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
