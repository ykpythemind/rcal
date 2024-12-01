class CreateGoogleCalendarChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :google_calendar_channels do |t|
      t.string :channel_id, null: true, index: { unique: true }
      t.belongs_to :user, null: false, foreign_key: true
      t.string :calendar_id, null: false, index: { unique: true } # 同じカレンダーは一つしか購読されないようにしとく
      t.string :next_sync_token
      t.datetime :expires_at

      t.timestamps
    end
  end
end
