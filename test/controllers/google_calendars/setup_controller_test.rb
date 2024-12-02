require "test_helper"

class GoogleCalendars::SetupControllerTest < ActionDispatch::IntegrationTest
  test "カレンダーを設定できる" do
    skip
    login_as(users(:one))

    post "/google_calendars/setup", params: { calendar_id: "test_calendar_id" }

    assert_response :redirect
  end
end
