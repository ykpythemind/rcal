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

ActiveRecord::Schema[8.0].define(version: 2025_01_01_154844) do
  create_table "google_access_tokens", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_google_access_tokens_on_user_id", unique: true
  end

  create_table "google_calendar_event_reschedules", force: :cascade do |t|
    t.integer "google_calendar_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["google_calendar_event_id"], name: "idx_on_google_calendar_event_id_a30aebc782"
  end

  create_table "google_calendar_events", force: :cascade do |t|
    t.integer "google_calendar_id", null: false
    t.string "event_id", null: false
    t.string "summary", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["event_id"], name: "index_google_calendar_events_on_event_id"
    t.index ["google_calendar_id"], name: "index_google_calendar_events_on_google_calendar_id"
    t.index ["status"], name: "index_google_calendar_events_on_status"
  end

  create_table "google_calendars", force: :cascade do |t|
    t.string "calendar_id", null: false
    t.string "channel_id"
    t.integer "user_id", null: false
    t.string "next_sync_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "summary"
    t.string "channel_resource_id"
    t.index ["calendar_id"], name: "index_google_calendars_on_calendar_id", unique: true
    t.index ["channel_id"], name: "index_google_calendars_on_channel_id", unique: true
    t.index ["user_id"], name: "index_google_calendars_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "message", null: false
    t.string "notification_type", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "email"
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "google_access_tokens", "users"
  add_foreign_key "google_calendar_event_reschedules", "google_calendar_events"
  add_foreign_key "google_calendar_events", "google_calendars"
  add_foreign_key "google_calendars", "users"
  add_foreign_key "notifications", "users"
end
