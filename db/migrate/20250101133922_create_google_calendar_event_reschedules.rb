class CreateGoogleCalendarEventReschedules < ActiveRecord::Migration[8.0]
  def change
    create_table :google_calendar_event_reschedules do |t|
      t.belongs_to :google_calendar_event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
