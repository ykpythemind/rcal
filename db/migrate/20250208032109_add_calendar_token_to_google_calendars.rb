class AddCalendarTokenToGoogleCalendars < ActiveRecord::Migration[8.0]
  def change
    add_column :google_calendars, :calendar_token, :string
  end
end
