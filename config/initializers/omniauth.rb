Rails.application.config.middleware.use OmniAuth::Builder do
  x = Rails.application.config.x
  provider :google_oauth2, x.google_client_id, x.google_client_secret,
    {
      scope: "openid, email, profile, calendar, offline",
      access_type: "offline",
      prompt: "consent"
    }
end
