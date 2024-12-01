class GoogleCalendars::SetupController < ApplicationController
  before_action :require_login

  def create
    calendar = current_user.google_calendars.find_or_initialize_by(calendar_id: params[:calendar_id])

    access_token = current_user.google_access_token.prepare

    if calendar.new_record?
      calendar.start_watch(access_token)

      # watch eventするだけで初回のイベントが飛んでくるので、SyncGoogleCalendarEventsJob.perform_later(calendar)は不要
    else
      # 新規にチャンネルをつくって古いのを消す
      new_calendar = calendar.dup
      calendar.destroy

      new_calendar.channel_id = SecureRandom.uuid
      new_calendar.start_watch(access_token)
    end

    redirect_to root_path
  end

  private
end
