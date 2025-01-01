class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :message, null: false
      t.string :notification_type, null: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
