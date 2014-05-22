Rails.application.routes.draw do
  

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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

  # User signup
  resources :users

  match '/signup', to: 'users#new', via: 'get'

  # User signin
  resources :sessions, only: [:new, :create, :destroy]
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  # Add Recipe
  resources :recipes do
    resources :ingredients
    resources :steps
  end  
  match '/upload', to: 'recipes#new', via: 'get'

  # Get users' own recipes
  match '/user/myrecipes' => 'users#myrecipes', :as => :myrecipes_user, via: 'get'
  
  # Add "addToMeal" method
  match '/recipe/addToMeal' => 'recipes#addToMeal', :as => :add_to_meal, via: 'post'

  # About page
  resources :about
  
  # Contact page
  resources :contact
  
  # Meals pages
  resources :meals
  
  # My Recipes page
  resources :my_recipes
  
  # Combined Recipes page
  resources :meal_schedules

  # Add Kitchen
  resources :kitchens do
	resources :users
  end

end
