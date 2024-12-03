class RescheduleJob < ApplicationJob
  def perform(calendar)
    calendar.google_calendar_events.where("end_at < ?", Time.current).find_each do |event|
      if event.reschedule_target_title?
        event.reschedule
      end
    end
  end
end
