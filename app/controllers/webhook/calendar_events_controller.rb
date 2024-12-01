class Webhook::CalendarEventsController < ApplicationController
  skip_forgery_protection

  def create
    puts params
    channel_id = request.headers["X-Goog-Channel-ID"]
    # channel_resource_id = request.headers["X-Goog-Resource-ID"]

    calendar = GoogleCalendar.find_by(channel_id: channel_id)
    if calendar
      SyncGoogleCalendarEventsJob.perform_later(calendar)
      head :ok
    else
      head :not_found
    end
  end
end
