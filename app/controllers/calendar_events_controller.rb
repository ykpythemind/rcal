class CalendarEventsController < ApplicationController
  before_action :require_login

  def index
    my_calendars = current_user.google_calendars
    events = GoogleCalendarEvent.active.joins(:google_calendar).merge(my_calendars).order(start_at: :asc)

    # 将来のもの全件取得する。効率悪いがきにしない
    @events = events.select { _1.reschedule_target_title? } # .take(10)

    # render turbo_stream: turbo_stream.replace("my-calendar-events")
  end
end
