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

ActiveRecord::Schema.define(version: 20160905010102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "keys", force: :cascade do |t|
    t.string   "key_identifier"
    t.string   "key_secret"
    t.integer  "rate_limit",     default: -1
    t.integer  "requests_used",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read_only",      default: true
  end

  create_table "lots", force: :cascade do |t|
    t.integer  "zone_id"
    t.string   "full_name"
    t.string   "short_name"
    t.integer  "total_spaces",         default: 0
    t.boolean  "is_staff_only",        default: false
    t.boolean  "is_restricted_access", default: false
    t.boolean  "is_trackable",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "used_spaces"
    t.index ["zone_id"], name: "index_lots_on_zone_id", using: :btree
  end

  create_table "sites", force: :cascade do |t|
    t.string   "full_name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zones", force: :cascade do |t|
    t.integer  "site_id"
    t.string   "full_name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id"], name: "index_zones_on_site_id", using: :btree
  end

end
