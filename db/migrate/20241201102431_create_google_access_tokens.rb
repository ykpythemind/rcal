class CreateGoogleAccessTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :google_access_tokens do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: { unique: true }
      t.string :access_token, null: false
      t.string :refresh_token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
