# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_01_132912) do
  create_table "google_access_tokens", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_google_access_tokens_on_user_id", unique: true
  end

  create_table "google_calendar_channels", force: :cascade do |t|
    t.string "channel_id"
    t.integer "user_id", null: false
    t.string "calendar_id", null: false
    t.string "next_sync_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_google_calendar_channels_on_calendar_id", unique: true
    t.index ["channel_id"], name: "index_google_calendar_channels_on_channel_id", unique: true
    t.index ["user_id"], name: "index_google_calendar_channels_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "google_access_tokens", "users"
  add_foreign_key "google_calendar_channels", "users"
end
