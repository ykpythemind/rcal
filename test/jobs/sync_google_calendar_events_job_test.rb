require "test_helper"

class SyncGoogleCalendarEventsJobTest < ActiveJob::TestCase
  test "sync calendar (first time)" do
    travel_to Time.zone.local(2025, 1, 15, 0, 0, 0)

    event_list_response_body = {
      nextSyncToken: "next_sync_token_1",
      items: [
        {
          id: "1", status: "cancelled", summary: "test1", start: { dateTime: Time.zone.now.iso8601 }, end: { dateTime: (Time.zone.now + 1.hour).iso8601 }
        },
        {
          id: "2", status: "confirmed", summary: "test2", start: { dateTime: Time.zone.local(2021, 1, 1, 0, 0, 0).iso8601 }, end: { dateTime: Time.zone.local(2021, 1, 1, 1, 0, 0).iso8601 }
        }
      ]
    }.to_json

    stub_request(:get, "https://www.googleapis.com/calendar/v3/calendars/dummy_calendar_id/events?showDeleted=true&singleEvents=true&timeMax=2025-02-15T00:00:00%2B09:00&timeMin=2025-01-15T00:00:00%2B09:00").
    to_return(status: 200, body: event_list_response_body, headers: { "Content-Type": "application/json" })

    calendar = google_calendars(:first_time_calendar)

    perform_enqueued_jobs do
      SyncGoogleCalendarEventsJob.perform_later(calendar)
    end

    calendar.reload
    assert { calendar.google_calendar_events.count == 1 }
    assert { calendar.next_sync_token == "next_sync_token_1" }

    assert { calendar.google_calendar_events.sole.event_id == "2" }
  end

  test "sync calendar (second time)" do
    event_list_response_body = {
      nextSyncToken: "next_sync_token_2",
      items: [
        {
          id: "1", status: "cancelled", summary: "test1", start: { dateTime: Time.zone.now.iso8601 }, end: { dateTime: (Time.zone.now + 1.hour).iso8601 }
        },
        {
          id: "2", status: "confirmed", summary: "test2", start: { dateTime: Time.zone.local(2021, 1, 1, 0, 0, 0).iso8601 }, end: { dateTime: Time.zone.local(2021, 1, 1, 1, 0, 0).iso8601 }
        }
      ]
    }.to_json

    stub_request(:get, "https://www.googleapis.com/calendar/v3/calendars/dummy_calendar_id/events?showDeleted=true&singleEvents=true&syncToken=sync_token").
    to_return(status: 200, body: event_list_response_body, headers: { "Content-Type": "application/json" })

    calendar = google_calendars(:first_time_calendar)
    calendar.update!(next_sync_token: "sync_token")

    perform_enqueued_jobs do
      SyncGoogleCalendarEventsJob.perform_later(calendar)
    end

    calendar.reload
    assert { calendar.google_calendar_events.count == 1 }
    assert { calendar.next_sync_token == "next_sync_token_2" }

    assert { calendar.google_calendar_events.sole.event_id == "2" }
  end
end
