class AddStatusToEvent < ActiveRecord::Migration[8.0]
  def change
    add_column :google_calendar_events, :status, :string

    add_index :google_calendar_events, :status
  end
end
