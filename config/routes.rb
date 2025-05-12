Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "trader/portfolios#index"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  namespace :trader do
    post 'add_balance', to: 'portfolios#add_balance', as: :add_balance
    resources :portfolios
    resources :transactions do
      collection do
        get :get_stock_price
      end
    end
  end

  namespace :admin do
    root to: "users#index"
    resources :users do
      member do
        get :edit_password
        patch :update_password
        patch :approve
      end
      collection do
        get :pending
      end
    end
    resources :transactions, only: [:index, :show, :destroy]
  end
end
