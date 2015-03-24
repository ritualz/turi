# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150317121036) do

  create_table "api_access_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.integer  "api_provider_id"
    t.string   "token",                        null: false
    t.string   "item",            default: ""
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "api_access_tokens", ["api_provider_id"], name: "index_api_access_tokens_on_api_provider_id"
  add_index "api_access_tokens", ["trip_id"], name: "index_api_access_tokens_on_trip_id"
  add_index "api_access_tokens", ["user_id", "trip_id", "api_provider_id"], name: "index_tokens_on_use_and_trip_and_provider", unique: true
  add_index "api_access_tokens", ["user_id"], name: "index_api_access_tokens_on_user_id"

  create_table "api_providers", force: :cascade do |t|
    t.string "name"
  end

  add_index "api_providers", ["name"], name: "index_api_providers_on_name", unique: true

  create_table "equipment_assignments", force: :cascade do |t|
    t.integer  "number"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "equipment_item_id"
    t.integer  "user_id"
  end

  add_index "equipment_assignments", ["equipment_item_id"], name: "index_equipment_assignments_on_equipment_item_id"
  add_index "equipment_assignments", ["user_id"], name: "index_equipment_assignments_on_user_id"

  create_table "equipment_items", force: :cascade do |t|
    t.string   "name"
    t.float    "price",             default: 0.0
    t.integer  "number",            default: 1
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "equipment_list_id"
    t.integer  "user_id"
  end

  add_index "equipment_items", ["equipment_list_id"], name: "index_equipment_items_on_equipment_list_id"
  add_index "equipment_items", ["user_id"], name: "index_equipment_items_on_user_id"

  create_table "equipment_lists", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "icon"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "trip_id"
  end

  add_index "equipment_lists", ["trip_id"], name: "index_equipment_lists_on_trip_id"

  create_table "events", force: :cascade do |t|
    t.string   "name",                     null: false
    t.text     "description", default: ""
    t.string   "color",                    null: false
    t.datetime "start_date",               null: false
    t.datetime "end_date",                 null: false
    t.integer  "trip_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "location"
  end

  add_index "events", ["trip_id"], name: "index_events_on_trip_id"

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true

  create_table "participant_roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "participant_roles", ["name"], name: "index_participant_roles_on_name", unique: true

  create_table "participants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "participant_role_id"
  end

  add_index "participants", ["participant_role_id"], name: "index_participants_on_participant_role_id"
  add_index "participants", ["trip_id"], name: "index_participants_on_trip_id"
  add_index "participants", ["user_id", "trip_id"], name: "index_participants_on_user_id_and_trip_id", unique: true
  add_index "participants", ["user_id"], name: "index_participants_on_user_id"

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "trips", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.text     "start_loc"
    t.text     "end_loc"
    t.text     "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "start_date"
    t.text     "end_date"
    t.integer  "user_id"
  end

  add_index "trips", ["user_id"], name: "index_trips_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name",                                null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "town"
    t.integer  "age"
    t.string   "status"
    t.text     "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
