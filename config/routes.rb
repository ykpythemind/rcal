Rails.application.routes.draw do
  namespace :google_calendars do
    get "setup/create"
  end
  root "root#index"

  post "/webhook/calendar_events", to: "webhook/calendar_events#create"

  get "up" => "rails/health#show", as: :rails_health_check

  get "/auth/google_oauth2/callback" => "google_callbacks#create"

  get "/google_calendars" => "google_calendars#index"
  post "/google_calendars/setup" => "google_calendars/setup#create"

  post "/logout" => "sessions#destroy"

  get "/terms" => "root#terms"
  get "/privacy" => "root#privacy"
end
