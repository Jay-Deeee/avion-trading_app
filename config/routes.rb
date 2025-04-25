Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "portfolios#index"

  devise_for :users

  resources :portfolios
  resources :transactions

  namespace :admin do
    resources :portfolios
    resources :transactions
  end
end
