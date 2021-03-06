Rails.application.routes.draw do

  constraints lambda {|r| r.subdomain.present? && r.subdomain != 'www'} do
    devise_for :users, :controllers => {:registrations => "registrations"}
    namespace :api do
      resources :herd_weeklies
      resources :weekly_tasks, only: [:update, :create, :destroy]
      resources :goals
      resources :sections, only: [:update] do
        resources :comments, only: [:index, :create, :destroy]
      end
      resources :focus_areas, only: [:index, :create, :destroy, :update]
      resources :uploads, only:[] do
        post 'profile', on: :collection
      end
      resources :users, only: [:index] do
        post 'login_todoist', on: :member
        post 'feedback', on: :collection
      end
      resources :user_weeklies, only: [:update]
      resources :activities, only: [:index]

    end

    get '/join', to: redirect('/users/sign_up')
    get "/" => 'herds#show', as: 'show_herd'
    get "/*a" => 'herds#show'

  end
  
  get '/new' => "herds#new", as: 'new_herd'
  post '/herds' => "herds#create"
  root "onboarding#index"
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
