
class SyncGoogleCalendarEventsJob < ApplicationJob
  def perform(calendar_channel)
    access_token = calendar_channel.user.google_access_token&.prepare

    return unless access_token

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token

    calendar_channel.with_lock do
      calendar_id = calendar_channel.calendar_id

      params =
        if calendar_channel.next_sync_token.present?
          { sync_token: calendar_channel.next_sync_token }
        else
          now = Time.zone.now
          { time_min: now.beginning_of_day.iso8601, time_max: (now + 1.month).iso8601 }
        end

      params.merge!(show_deleted: true, single_events: true)

      events = service.list_events(calendar_id, **params)

      calendar_channel.update!(next_sync_token: events.next_sync_token)

      events.items.each do |event|
        puts event.inspect
      end
    end
  end
end
