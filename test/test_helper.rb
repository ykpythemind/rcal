ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "webmock/minitest"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login_as(user)
      auth_hash = {
        provider: "google_oauth2",
        uid: user.uid,
        credentials: {
          token: "test_token",
          refresh_token: "test_refresh_token",
          expires_at: Time.zone.parse("2030-01-01 00:00:00").to_i
        },
        info: {
          email: "test@example.com",
          name: "test user"
        }
      }

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(auth_hash)

      get "/auth/google_oauth2/callback"
      assert_response :redirect
    end

    teardown do
      OmniAuth.config.test_mode = false
    end
  end
end
