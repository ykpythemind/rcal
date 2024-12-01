class GoogleCalendars::SetupController < ApplicationController
  before_action :require_login

  def create
    calendar_channel = current_user.google_calendar_channels.find_or_initialize_by(calendar_id: params[:calendar_id])

    access_token = current_user.google_access_token.prepare

    if calendar_channel.new_record?
      calendar_channel.start_watch(access_token)

      # watch eventするだけで初回のイベントが飛んでくるので、SyncGoogleCalendarEventsJob.perform_later(calendar_channel)は不要
    else
      # ... maybe recreate channel
      SyncGoogleCalendarEventsJob.perform_later(calendar_channel)
    end

    redirect_to root_path
  end

  private
end
