Rails.application.routes.draw do
  root "root#index"

  get "up" => "rails/health#show", as: :rails_health_check

  get "/auth/google_oauth2/callback" => "google_callbacks#create"
end
