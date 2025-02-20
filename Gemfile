source "https://rubygems.org"

gem "rails", "~> 8.0.0"
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false

gem "kamal", require: false

gem "thruster", require: false
# gem "image_processing", "~> 1.2"

gem "omniauth"
gem "omniauth-rails_csrf_protection"
gem "omniauth-google-oauth2"
gem "google-apis-calendar_v3", require: "google/apis/calendar_v3"

gem "tailwindcss-rails", "~> 4.1"
gem "importmap-rails", "~> 2.1"
gem "turbo-rails"
gem "activerecord-session_store"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  gem "brakeman", require: false

  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "webmock"
  gem "minitest-power_assert"
end
