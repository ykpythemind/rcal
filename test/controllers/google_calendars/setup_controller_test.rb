require "test_helper"

class GoogleCalendars::SetupControllerTest < ActionDispatch::IntegrationTest
  test "カレンダーを設定できる" do
    login_as(users(:one))

    WebMock.disable_net_connect!

    calendar_resp = <<-JSON
        {
          "id": "test@example.com",
          "summary": "calendar1"
        }
    JSON

    stub_request(:get, "https://www.googleapis.com/calendar/v3/calendars/test_calendar_id").
    to_return(status: 200, body: calendar_resp, headers: { "Content-Type": "application/json" })

    watch_resp = <<-JSON
      {
        "kind": "api#channel",
        "id": "---dummy---",
        "resourceId": "test_resource_id",
        "resourceUri": "https://www.googleapis.com/calendar/v3/calendars/test_calendar_id/events",
        "expiration": "1609459200000"
      }
    JSON

    stub_request(:post, "https://www.googleapis.com/calendar/v3/calendars/test_calendar_id/events/watch?showDeleted=true").
    with { |request|
      body = JSON.parse(request.body)
      assert { body["address"] == "https://example.com/webhook/calendar_events" }
      assert { body["type"] == "web_hook" }
      assert body["id"].present?
    }.
    to_return(status: 200, body: watch_resp, headers: { "Content-Type": "application/json" })

    assert_changes -> { GoogleCalendar.count }, 1 do
      post "/google_calendars/setup", params: { calendar_id: "test_calendar_id" }
    end

    google_calendar = GoogleCalendar.last!
    assert { google_calendar.calendar_id == "test_calendar_id" }
    assert { google_calendar.channel_resource_id == "test_resource_id" }
    assert { google_calendar.summary == "calendar1" }

    at_matcher = ->(job_at) { (Time.zone.local(2021, 1, 1, 8)..Time.zone.local(2021, 1, 1, 9)).cover?(job_at) }

    assert_enqueued_with(job: SyncGoogleCalendarEventsJob)
    assert_enqueued_with(job: RefreshCalendarWatchJob, at: at_matcher)

    assert_response :redirect
  end
end
