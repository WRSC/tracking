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

ActiveRecord::Schema.define(version: 20150805102906) do

  create_table "attempts", force: :cascade do |t|
    t.string   "name"
    t.datetime "start"
    t.datetime "end"
    t.integer  "robot_id"
    t.integer  "mission_id"
    t.integer  "tracker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coordinates", force: :cascade do |t|
    t.integer  "tracker_id"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "datetime"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "speed"
    t.string   "course"
  end

  create_table "markers", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "mission_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "latitude"
    t.string   "longitude"
    t.string   "mtype"
    t.string   "datetime"
  end

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "role"
    t.string   "logo"
    t.integer  "team_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  create_table "missions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "start"
    t.datetime "end"
  end

  create_table "robots", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.integer  "team_id",    null: false
    t.integer  "tracker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "attempt_id"
    t.integer  "timecost"
    t.float    "rawscore"
    t.float    "penalty"
    t.datetime "datetimes"
    t.integer  "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "logo"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "leader_id"
  end

  create_table "trackers", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

end
