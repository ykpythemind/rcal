class AddChannelResourceId < ActiveRecord::Migration[8.0]
  def change
    add_column :google_calendars, :channel_resource_id, :string, comment: "Google Calendar APIで使うresourceID。channel_idと同じかと思いきやそうではないっぽい"
  end
end
