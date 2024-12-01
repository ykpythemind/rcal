require "test_helper"

class GoogleCalendarsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get google_calendars_index_url
    assert_response :success
  end
end
