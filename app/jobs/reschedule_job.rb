class RescheduleJob < ApplicationJob
  def perform(calendar)
    calendar.google_calendar_events.where("end_at < ?", Time.current).find_each do |event|
      # 終了時間がすぎているものをもう一度持ってくる
      if event.reschedule_target_title?
        event.reschedule
      end
    end
  end
end
