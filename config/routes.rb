Rails.application.routes.draw do
  root "root#index"

  post "/", to: "webhook/calendar_events#create"

  get "up" => "rails/health#show", as: :rails_health_check

  get "/auth/google_oauth2/callback" => "google_callbacks#create"

  get "/google_calendars" => "google_calendars#index"

  post "/logout" => "sessions#destroy"
end
