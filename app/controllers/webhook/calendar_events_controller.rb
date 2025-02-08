class Webhook::CalendarEventsController < ApplicationController
  skip_forgery_protection

  def create
    channel_id = request.headers["X-Goog-Channel-ID"]

    # ⇣このリクエストがどのリソースに関連しているかを知るための情報。これは無視してよいようだ
    # channel_resource_id = request.headers["X-Goog-Resource-ID"]

    calendar = GoogleCalendar.find_by(channel_id: channel_id)
    if calendar
      if request.headers["X-Goog-Channel-Token"] != calendar.calendar_token
        Rails.logger.warn("Invalid token")
        head :bad_request
        return
      end

      SyncGoogleCalendarEventsJob.perform_later(calendar)
      head :ok
    else
      head :not_found
    end
  end
end
