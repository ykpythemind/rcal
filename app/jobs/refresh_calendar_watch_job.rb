class RefreshCalendarWatchJob < ApplicationJob
  def perform(calendar)
    access_token = calendar.user.google_access_token&.prepare
    return unless access_token
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token

    calendar.refresh_watch(access_token)
  end
end
