require "test_helper"

class CalendarEventsControllerTest < ActionDispatch::IntegrationTest
  test "show calendar events" do
    freeze_time

    login_as(users(:one))

    GoogleCalendarEvent.create!(google_calendar: google_calendars(:first_time_calendar), event_id: "t1", start_at: Time.current + 24.hours, end_at: Time.current + 25.hours, summary: "r test")
    GoogleCalendarEvent.create!(google_calendar: google_calendars(:first_time_calendar), event_id: "t2", start_at: Time.current + 24.hours, end_at: Time.current + 25.hours, summary: "not recurring event test")

    get "/calendar_events"
    assert_response :ok
  end
end
