
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

      events = service.list_events(calendar_id, **params)

      calendar.update!(next_sync_token: events.next_sync_token)

      events.items.each do |event|
        Rails.logger.info event.inspect

        record = calendar.google_calendar_events.find_or_initialize_by(
          event_id: event.id,
        )

        if event.status == "cancelled"
          if record.persisted?
            record.destroy! # TODO: status更新のみにする
          else
            # ignore
          end
        else
          record.assign_attributes(
            start_at: event.start.date_time,
            end_at: event.end.date_time,
            summary: event.summary,
            data: event.to_h,
            status: event.status,
          )

          record.save!
        end
      end
    end
  end
end
