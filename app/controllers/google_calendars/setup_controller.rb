class GoogleCalendars::SetupController < ApplicationController
  before_action :require_login

  def new
  end

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
      calendar.refresh_watch(access_token)
    end

    flash[:notice] = "カレンダーを設定しました"
    redirect_to root_path
  end

  private
end
