require "test_helper"

class SyncGoogleCalendarEventsJobTest < ActiveJob::TestCase
  test "sync calendar (first time)" do
    calendar = google_calendars(:first_time_calendar)

    perform_enqueued_jobs do
      SyncGoogleCalendarEventsJob.perform_later(calendar)
    end
  end
end
