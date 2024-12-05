require "test_helper"

class SchedulerTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "終了時刻を過ぎているイベントをリスケする" do
    travel_to Time.zone.local(2024, 12, 1, 10, 0, 0)

    calendar = google_calendars(:my_calendar)
    calendar.google_calendar_events.create!(
      summary: "old",
      event_id: "old",
      start_at: Time.current - 1.hour,
      end_at: Time.current - 30.minutes
    )
    calendar.google_calendar_events.create!(
      summary: "future",
      event_id: "future",
      start_at: Time.current + 1.hour,
      end_at: Time.current + 30.minutes
    )
    target_event = calendar.google_calendar_events.create!(
      summary: "r test",
      event_id: "old_target",
      start_at: Time.current - 1.hour,
      end_at: Time.current - 30.minutes
    )

    WebMock.disable_net_connect!

    stub_request(:patch, "https://www.googleapis.com/calendar/v3/calendars/dummy_calendar_id2/events/old_target").
      with { |request |
        body = JSON.parse(request.body)
        assert { body["start"]["dateTime"] == "2024-12-01T11:30:00+09:00" }
        assert { body["start"]["timeZone"] == "Asia/Tokyo" }
        assert { body["end"]["dateTime"] == "2024-12-01T12:00:00+09:00" }
        assert { body["end"]["timeZone"] == "Asia/Tokyo" }
      }.
    to_return(status: 200, body: "", headers: {})

    perform_enqueued_jobs do
      Scheduler.call
    end

    target_event.reload
    assert { target_event.start_at == Time.zone.local(2024, 12, 1, 11, 30, 0) }
    assert { target_event.end_at == Time.zone.local(2024, 12, 1, 12, 0, 0) }
  end
end
