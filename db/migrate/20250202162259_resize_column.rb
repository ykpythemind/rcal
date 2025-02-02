class ResizeColumn < ActiveRecord::Migration[8.0]
  def change
    change_column :google_calendar_events, :summary, :string, limit: 1020
    change_column :users, :email, :string, limit: 510
    remove_column :google_calendar_events, :data
  end
end
