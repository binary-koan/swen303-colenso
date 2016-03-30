Rails.application.routes.draw do
  get  "/"    => "documents#index", as: :documents
  get  "/new" => "documents#new",   as: :new_document
  post "/"    => "documents#create"

  get "/browse(/*folder)" => "documents#browse",         as: :browse_documents
  get "/search"           => "documents#search",         as: :search_documents
  get "/statistics"       => "documents#statistics",     as: :documents_statistics
  get "/search_records"   => "documents#search_records", as: :search_records
  get "/download_all"     => "documents#download_all",   as: :download_all_documents

  get "/document/*id/download" => "documents#download", as: :download_document
  get "/document/*id/edit"     => "documents#edit",     as: :edit_document
  get "/document/*id"          => "documents#show",     as: :document
  put "/document/*id"          => "documents#update"

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
