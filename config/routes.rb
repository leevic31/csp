Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Defines the root path route ("/")
  # root "posts#index"

  get 'users/index'
  get 'users/show'
  get 'home/index'
  devise_for :users
  root "home#index"

  resources :folders do
    resources :file_uploads, only: [:create, :index, :destroy, :new, :show, :update] do
      member do
        get 'download'
      end

      resources :file_shares, only: [:new, :create], controller: 'file_shares'
    end
  end

  resources :users, only: [:index, :show] do
    resources :folders, only: [:index] do
      resources :file_uploads, only: [:index]
    end
  end

  resources :audit_logs, only: [:index]

  resources :notifications, only: [:index]
end
