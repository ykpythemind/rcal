class GoogleCalendars::SetupController < ApplicationController
  before_action :require_login

  def create
    calendar = current_user.google_calendars.find_or_initialize_by(calendar_id: params[:calendar_id])

    access_token = current_user.google_access_token.prepare

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token
    cal = service.get_calendar(calendar.calendar_id)
    calendar.summary = cal.summary

    if calendar.new_record?
      calendar.start_watch(access_token)

    else
      # 新規にチャンネルをつくって古いのを消す
      calendar.stop_watching_channel
      calendar.update!(channel_id: nil, channel_resource_id: nil, expires_at: nil, next_sync_token: nil)
      calendar.start_watch(access_token)
    end

    redirect_to root_path
  end

  private
end
