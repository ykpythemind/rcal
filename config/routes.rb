Rails.application.routes.draw do
  root "root#index"

  post "/webhook/calendar_events", to: "webhook/calendar_events#create"

  get "up" => "rails/health#show", as: :rails_health_check

  get "/auth/google_oauth2/callback" => "google_callbacks#create"

  get "/google_calendars" => "google_calendars#index"
  get "/google_calendars/*calendar_id/edit" => "google_calendars#edit"
  delete "/google_calendars/:calendar_id" => "google_calendars#destroy", calendar_id: /[^\/]+/
  post "/google_calendars/setup" => "google_calendars/setup#create"
  get "/google_calendars/setup/new" => "google_calendars/setup#new"

  post "/logout" => "sessions#destroy"

  get "/terms" => "root#terms"
  get "/privacy" => "root#privacy"
  get "/howto" => "root#howto"

  get "/users/delete" => "user_deletes#show"
  post "/users/delete" => "user_deletes#create"

  get "/mypage" => "mypage#index"

  get "/calendar_events" => "calendar_events#index"
  delete "/notifications/:id" => "notifications#destroy"

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
