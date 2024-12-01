require "test_helper"

class GoogleCalendars::SetupControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get google_calendars_setup_create_url
    assert_response :success
  end
end
