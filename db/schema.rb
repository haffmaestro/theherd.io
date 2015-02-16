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

ActiveRecord::Schema.define(version: 20150216030035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "herd_id"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "section_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
  end

  add_index "comments", ["section_id"], name: "index_comments_on_section_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "focus_areas", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "focus_areas", ["user_id"], name: "index_focus_areas_on_user_id", using: :btree

  create_table "goals", force: true do |t|
    t.boolean  "done"
    t.datetime "due_date"
    t.integer  "focus_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
  end

  add_index "goals", ["focus_area_id"], name: "index_goals_on_focus_area_id", using: :btree

  create_table "herd_weeklies", force: true do |t|
    t.integer  "herd_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.integer  "week"
  end

  add_index "herd_weeklies", ["herd_id"], name: "index_herd_weeklies_on_herd_id", using: :btree

  create_table "herds", force: true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "name"
    t.integer  "user_weekly_id"
    t.integer  "focus_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
  end

  add_index "sections", ["focus_area_id"], name: "index_sections_on_focus_area_id", using: :btree
  add_index "sections", ["user_weekly_id"], name: "index_sections_on_user_weekly_id", using: :btree

  create_table "user_weeklies", force: true do |t|
    t.integer  "herd_weekly_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "done",           default: false
  end

  add_index "user_weeklies", ["herd_weekly_id"], name: "index_user_weeklies_on_herd_weekly_id", using: :btree
  add_index "user_weeklies", ["user_id"], name: "index_user_weeklies_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "herd_id"
    t.string   "subdomain"
    t.string   "todoist_api_token"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email", "subdomain"], name: "index_users_on_email_and_subdomain", unique: true, using: :btree
  add_index "users", ["herd_id"], name: "index_users_on_herd_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weekly_tasks", force: true do |t|
    t.string   "body"
    t.boolean  "done"
    t.datetime "due_date"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekly_tasks", ["section_id"], name: "index_weekly_tasks_on_section_id", using: :btree

end
