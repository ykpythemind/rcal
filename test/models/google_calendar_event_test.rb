require "test_helper"

class GoogleCalendarEventTest < ActiveSupport::TestCase
  test "#new_schedule" do
    calendar = google_calendars(:my_calendar)

    travel_to("2021-01-01T20:00:00+09:00")

    # next morning
    event1 = GoogleCalendarEvent.create!(google_calendar: calendar, start_at: "2021-01-01T23:00:00+09:00", end_at: "2021-01-02T01:00:00+09:00", summary: "test title", event_id: "123")
    assert { event1.new_schedule == [ "2021-01-02T09:00:00+09:00", "2021-01-02T11:00:00+09:00" ] }

    # after 2 hours
    event2 = GoogleCalendarEvent.create!(google_calendar: calendar, start_at: "2021-01-01T11:00:00+09:00", end_at: "2021-01-01T13:00:00+09:00", summary: "test title 2", event_id: "124")
    assert { event2.new_schedule == [ "2021-01-01T15:00:00+09:00", "2021-01-01T17:00:00+09:00" ] }

    # older events
    event3 = GoogleCalendarEvent.create!(google_calendar: calendar, start_at: "2019-09-01T11:00:00+09:00", end_at: "2019-09-01T13:00:00+09:00", summary: "test title 3", event_id: "125")
    assert { event3.new_schedule == [ "2021-01-01T15:00:00+09:00", "2021-01-01T17:00:00+09:00" ] }
  end

  test "#reschedule_target_title?" do
    [
      [ { summary: "test title" }, false ],
      [ { summary: "rtest title" }, true ],
      [ { summary: "r test title" }, true ],
      [ { summary: "r-test title" }, true ],
      [ { summary: "r:test title" }, true ],
      [ { summary: "r=test title" }, true ]
    ].each do |(attributes, expected)|
      event = GoogleCalendarEvent.new(attributes)
      assert { event.reschedule_target_title? == expected }
    end
  end

  test "#generate_decorated_summary" do
    calendar = google_calendars(:my_calendar)
    event = GoogleCalendarEvent.create!(google_calendar: calendar, start_at: "2021-01-01T11:00:00+09:00", end_at: "2021-01-01T13:00:00+09:00", summary: "r-test title", event_id: "124")
    assert { event.generate_decorated_summary == "r-test title 🔄" }

    event.google_calendar_event_reschedules.create!
    assert { event.generate_decorated_summary == "r-test title 🔄" }
  end
end
