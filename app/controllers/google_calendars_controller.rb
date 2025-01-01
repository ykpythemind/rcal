class GoogleCalendarsController < ApplicationController
  before_action :require_login
  before_action :set_google_calendar, only: %i[edit destroy]

  def index
    access_token = current_user.google_access_token.prepare

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token

    @calendars = []

    page_token = nil
    loop do
      response =
        service.list_calendar_lists(
          fields: "items/id,items/summary,next_page_token",
          page_token:,
          min_access_role: "writer",
        )

        @calendars += response.items

      page_token = response.next_page_token
      break if page_token.nil?
    end
  end

  def edit
  end

  def destroy
    @google_calendar.destroy!

    flash[:notice] = "カレンダー設定を削除しました"
    redirect_to mypage_path
  end

  private

  def set_google_calendar
    @google_calendar = current_user.google_calendars.find_by!(calendar_id: params[:calendar_id])
  end
end
