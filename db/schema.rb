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

ActiveRecord::Schema.define(version: 20170222025947) do

  create_table "guild_rp_snapshots", force: :cascade do |t|
    t.integer  "guild_id"
    t.date     "snapshot_date"
    t.integer  "total_rps"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "guild_rp_snapshots", ["guild_id"], name: "index_guild_rp_snapshots_on_guild_id"

  create_table "guilds", force: :cascade do |t|
    t.string   "name"
    t.integer  "realm"
    t.integer  "total_rps"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "last_three_days_rps",    default: 0
    t.integer  "last_seven_days_rps",    default: 0
    t.integer  "last_fourteen_days_rps", default: 0
  end

  add_index "guilds", ["name"], name: "index_guilds_on_name", unique: true

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "realm_level"
    t.datetime "last_api_update"
    t.integer  "race"
    t.integer  "daoc_class"
    t.integer  "realm"
    t.integer  "total_rps"
    t.integer  "guild_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "last_three_days_rps",    default: 0
    t.integer  "last_seven_days_rps",    default: 0
    t.integer  "last_fourteen_days_rps", default: 0
  end

  add_index "players", ["guild_id"], name: "index_players_on_guild_id"
  add_index "players", ["name"], name: "index_players_on_name", unique: true

  create_table "rp_snapshots", force: :cascade do |t|
    t.integer  "player_id"
    t.date     "snapshot_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "total_rp"
  end

  add_index "rp_snapshots", ["player_id"], name: "index_rp_snapshots_on_player_id"

end
