require "test_helper"

class SyncGoogleCalendarEventsJobTest < ActiveJob::TestCase
  test "sync calendar (first time)" do
    calendar = google_calendars(:first_time_calendar)

    perform_enqueued_jobs do
      SyncGoogleCalendarEventsJob.perform_later(calendar)
    end

    calendar.reload
    assert { calendar.google_calendar_events.count == 1 }
    assert { calendar.next_sync_token == "next_sync_token" }

    assert { calendar.google_calendar_events.sole.event_id == "2" }
  end

  test "sync calendar (second time)" do
    calendar = google_calendars(:first_time_calendar)
    calendar.update!(next_sync_token: "sync_token")

    # TODO: better test

    perform_enqueued_jobs do
      SyncGoogleCalendarEventsJob.perform_later(calendar)
    end

    calendar.reload
    assert { calendar.google_calendar_events.count == 1 }
    assert { calendar.next_sync_token == "next_sync_token" }

    assert { calendar.google_calendar_events.sole.event_id == "2" }
  end
end
