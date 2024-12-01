
class SyncGoogleCalendarEventsJob < ApplicationJob
  def perform(calendar_channel)
    calendar = calendar_channel.calendar_id
  end
end
