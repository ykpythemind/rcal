class AddSummaryToCalendars < ActiveRecord::Migration[8.0]
  def change
    add_column :google_calendars, :summary, :string, null: true
  end
end
