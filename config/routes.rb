Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "trader/portfolios#index"

  devise_for :users

  namespace :trader do
    resources :portfolios
    resources :transactions
  end

  namespace :admin do
    resources :portfolios
    resources :transactions
  end
end
