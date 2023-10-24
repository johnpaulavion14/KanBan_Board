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

ActiveRecord::Schema[7.0].define(version: 2023_10_24_023227) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addcards", force: :cascade do |t|
    t.string "card_name"
    t.text "desc"
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addcomments", force: :cascade do |t|
    t.text "comment"
    t.string "first_name"
    t.string "last_name"
    t.integer "addcard_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", force: :cascade do |t|
    t.string "card_title"
    t.integer "create_board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "create_boards", force: :cascade do |t|
    t.string "board_title"
    t.string "board_desc"
    t.integer "user_id"
    t.boolean "group", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "links", force: :cascade do |t|
    t.integer "source"
    t.integer "target"
    t.string "link_type", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "message"
    t.string "first_name"
    t.string "last_name"
    t.string "time"
    t.integer "milestone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "milestones", force: :cascade do |t|
    t.string "task_name"
    t.date "start"
    t.date "finish"
    t.text "assigned"
    t.integer "complete"
    t.date "date_completed"
    t.text "output"
    t.text "remarks"
    t.integer "rock_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profilepics", force: :cascade do |t|
    t.string "avatar"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_workspaces", force: :cascade do |t|
    t.string "folder_name"
    t.text "assigned"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rockmessages", force: :cascade do |t|
    t.text "message"
    t.string "first_name"
    t.string "last_name"
    t.string "time"
    t.integer "rock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rocks", force: :cascade do |t|
    t.string "task_name"
    t.date "start"
    t.date "finish"
    t.text "assigned"
    t.date "date_completed"
    t.text "output"
    t.text "remarks"
    t.integer "user_id"
    t.integer "project_workspace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "complete"
    t.string "reviewed_by", default: ""
  end

  create_table "sub2messages", force: :cascade do |t|
    t.text "message"
    t.string "first_name"
    t.string "last_name"
    t.string "time"
    t.integer "sub2milestone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub2milestones", force: :cascade do |t|
    t.string "task_name"
    t.date "start"
    t.date "finish"
    t.text "assigned"
    t.integer "complete"
    t.date "date_completed"
    t.text "output"
    t.text "remarks"
    t.integer "submilestone_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submessages", force: :cascade do |t|
    t.text "message"
    t.string "first_name"
    t.string "last_name"
    t.string "time"
    t.integer "submilestone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submilestones", force: :cascade do |t|
    t.string "task_name"
    t.date "start"
    t.date "finish"
    t.text "assigned"
    t.integer "complete"
    t.date "date_completed"
    t.text "output"
    t.text "remarks"
    t.integer "milestone_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "text"
    t.datetime "start_date"
    t.integer "duration"
    t.integer "parent"
    t.decimal "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sortorder", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "host", default: false
    t.boolean "scribe", default: false
    t.boolean "admin", default: false
    t.string "password_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
