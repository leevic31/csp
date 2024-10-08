Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :folders do
    resources :file_uploads, only: [:create, :index, :destroy] do
      member do
        get 'download'
      end
    end
  end

  resources :file_shares, only: [:create]
end
