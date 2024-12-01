Rails.application.routes.draw do
  root "root#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
