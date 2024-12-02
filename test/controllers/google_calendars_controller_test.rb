require "test_helper"

class GoogleCalendarsControllerTest < ActionDispatch::IntegrationTest
  test "show calendar list" do
    login_as(users(:one))

    WebMock.disable_net_connect!

    cal_body = <<-JSON
        {
         "items": [
          {
           "id": "test@example.com",
           "summary": "calendar1"
          },
          {
           "id": "ja.japanese#holiday@group.v.calendar.google.com",
           "summary": "日本の祝日"
          },
          {
           "id": "test2@example.com",
           "summary": "calendar2"
          }
         ]
        }
    JSON

    stub_request(:get, "https://www.googleapis.com/calendar/v3/users/me/calendarList?fields=items/id,items/summary,nextPageToken&minAccessRole=writer").
    to_return(status: 200, body: cal_body, headers: { "Content-Type": "application/json" })

    get "/google_calendars"
    assert_response :ok
  end
end
