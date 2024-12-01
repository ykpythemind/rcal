class GoogleAccessToken < ApplicationRecord
  belongs_to :user

  def prepare
    if expires_at < Time.current || ENV["FORCE_REFRESH_TOKEN"]
      client_id = Rails.application.config.x.google_client_id
      client_secret = Rails.application.config.x.google_client_secret
      refresher =
        Google::Auth::UserRefreshCredentials.new(refresh_token:, client_id:, client_secret:)
      refresher.fetch_access_token!

      update!(
        access_token: refresher.access_token,
        refresh_token: refresher.refresh_token,
        expires_at: refresher.expires_in.seconds.from_now
      )
    end

    access_token
  end
end
