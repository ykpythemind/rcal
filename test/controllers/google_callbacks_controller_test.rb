require "test_helper"

class GoogleCallbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    auth_hash = {
      provider: "google_oauth2",
      uid: "my_uid",
      info: {
        email: "test@example.com",
        name: "test user"
      },
      credentials: {
        token: "test_token",
        refresh_token: "test_refresh_token",
        expires_at: 1234567890
      }
    }

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(auth_hash)
  end

  test "auth and save access token" do
    get "/auth/google_oauth2/callback"
    assert_response :redirect

    user = User.find_by(uid: "my_uid")
    assert_equal "test_token", user.google_access_token.access_token
    assert_equal "test_refresh_token", user.google_access_token.refresh_token
    assert_equal Time.at(1234567890), user.google_access_token.expires_at
  end
end
