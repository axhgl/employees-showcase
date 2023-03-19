require 'sidekiq_unique_jobs/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root to: "employees#index"

  resources :employees
  resources :remote_data_fetches, only: :index

  delete "employees-bulk-destroy", to: "employees#bulk_destroy"
end
