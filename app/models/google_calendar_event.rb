class GoogleCalendarEvent < ApplicationRecord
  belongs_to :google_calendar

  MAGIC_TITLE = /^(r{1,})(\s|　)+/

  def reschedule_target_title?
    summary.match?(MAGIC_TITLE)
  end

  def new_schedule
    # now = Time.current
    will_start_at = end_at + 2.hour # とりあえず2時間ずつ後ろにずらしていく

    diff = (end_at - start_at).seconds

    if will_start_at.hour.in?([ 0, 1, 2, 3, 4, 5, 6, 7, 8 ])
      # その日の朝にする!
      will_start_at = will_start_at.change(hour: 9)
    elsif will_start_at.hour.in?([ 23 ])
      # 夜だからできない。次の日。
      will_start_at = will_start_at.change(hour: 9) + 1.day
    end

    will_end_at = will_start_at + diff # 期間を保持

    [ will_start_at, will_end_at ]
  end

  def reschedule
    access_token = google_calendar.user.google_access_token&.prepare
    raise "No access token" unless access_token

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token

    s, e = new_schedule

    new_event = Google::Apis::CalendarV3::Event.new(
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: s.iso8601,
        time_zone: s.time_zone.name,
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: e.iso8601,
        time_zone: e.time_zone.name,
      )
    )

    service.patch_event(
      google_calendar.calendar_id,
      event_id,
      new_event
    )

    update!(start_at: s, end_at: e)
  end
end
