class GoogleCalendarEvent < ApplicationRecord
  belongs_to :google_calendar

  def handle
    # todo handling

    save!
  end
end
