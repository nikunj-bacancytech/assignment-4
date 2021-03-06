Rails.application.routes.draw do
  root "home#index"
  resources :addresses
  resources :users do
    collection do
      post 'update-status' => 'users#update_status' 
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users 
    end
  end

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
