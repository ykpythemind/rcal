
class SyncGoogleCalendarEventsJob < ApplicationJob
  def perform(calendar)
    access_token = calendar.user.google_access_token&.prepare

    return unless access_token

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token

    calendar.with_lock do
      calendar_id = calendar.calendar_id

      params =
        if calendar.next_sync_token.present?
          { sync_token: calendar.next_sync_token }
        else
          now = Time.zone.now
          { time_min: now.beginning_of_day.iso8601, time_max: (now + 1.month).iso8601 }
        end

      params.merge!(show_deleted: true, single_events: true)

      events =
        if Rails.env.test?
          # FIXME: dirty hack for testing
          ev = Google::Apis::CalendarV3::Events.new
          ev.next_sync_token = "next_sync_token"

          ev.items = [
            Google::Apis::CalendarV3::Event.new.tap do |e|
              e.id = "1"
              e.status = "cancelled"
              e.start = Google::Apis::CalendarV3::EventDateTime.new(date_time: Time.zone.now)
              e.end = Google::Apis::CalendarV3::EventDateTime.new(date_time: Time.zone.now + 1.hour)
              e.summary = "test1"
            end,
            Google::Apis::CalendarV3::Event.new.tap do |e|
              e.id = "2"
              e.status = "confirmed"
              e.start = Google::Apis::CalendarV3::EventDateTime.new(date_time: Time.zone.local(2021, 1, 1, 0, 0, 0))
              e.end = Google::Apis::CalendarV3::EventDateTime.new(date_time: Time.zone.local(2021, 1, 1, 1, 0, 0))
              e.summary = "test2"
            end
          ]
          ev
        else
          service.list_events(calendar_id, **params)
        end

      calendar.update!(next_sync_token: events.next_sync_token)

      events.items.each do |event|
        Rails.logger.info event.inspect

        record = calendar.google_calendar_events.find_or_initialize_by(
          event_id: event.id,
        )

        if event.status == "cancelled"
          if record.persisted?
            record.destroy!
          else
            # ignore
          end
        else
          record.assign_attributes(
            start_at: event.start.date_time,
            end_at: event.end.date_time,
            summary: event.summary,
            data: event.to_h,
          )

          record.save!
        end
      end
    end
  end
end
