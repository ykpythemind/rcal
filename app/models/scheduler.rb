class Scheduler
  def self.call
    GoogleCalendar.all.find_each do |calendar|
      RescheduleJob.perform_later(calendar)
    end
  end
end
