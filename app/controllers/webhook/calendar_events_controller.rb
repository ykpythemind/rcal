class Webhook::CalendarEventsController < ApplicationController
  skip_forgery_protection

  def create
    puts params
    channel_id = request.headers["X-Goog-Channel-ID"]
    # channel_resource_id = request.headers["X-Goog-Resource-ID"]

    channel = GoogleCalendarChannel.find_by(channel_id: channel_id)
    if channel
      SyncGoogleCalendarEventsJob.perform_later(channel)
      head :ok
    else
      head :not_found
    end
  end
end
