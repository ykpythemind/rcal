require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Rcal
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = "Asia/Tokyo"
    config.yjit = false # メモリ節約

    config.x.host = ENV["HOST"] || "localhost:3000"

    I18n.available_locales = %i[ja en]
    I18n.default_locale = :ja

    config.active_record.encryption.primary_key = Rails.application.credentials.dig(:active_record_encryption, :primary_key)
    config.active_record.encryption.deterministic_key = Rails.application.credentials.dig(:active_record_encryption, :deterministic_key)
    config.active_record.encryption.key_derivation_salt = Rails.application.credentials.dig(:active_record_encryption, :key_derivation_salt)
  end
end
