class CreateGoogleCalendarEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :google_calendar_events do |t|
      t.belongs_to :google_calendar, null: false, foreign_key: true
      t.string :event_id, null: false, index: true # { unique: true }
      t.string :summary, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.json :data

      t.timestamps
    end
  end
end
