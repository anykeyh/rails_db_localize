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

ActiveRecord::Schema.define(version: 20150907053908) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rails_db_localize_translations", force: :cascade do |t|
    t.string  "resource_type"
    t.integer "resource_id"
    t.string  "field"
    t.string  "lang"
    t.integer "compound_key"
    t.text    "content"
  end

  add_index "rails_db_localize_translations", ["compound_key", "field", "lang"], name: "index_rdblt_cfl", using: :btree
  add_index "rails_db_localize_translations", ["compound_key", "field"], name: "index_rdblt_cf", using: :btree
  add_index "rails_db_localize_translations", ["compound_key"], name: "index_rails_db_localize_translations_on_compound_key", using: :btree
  add_index "rails_db_localize_translations", ["field"], name: "index_rails_db_localize_translations_on_field", using: :btree
  add_index "rails_db_localize_translations", ["lang"], name: "index_rails_db_localize_translations_on_lang", using: :btree
  add_index "rails_db_localize_translations", ["resource_id", "resource_type", "field", "lang"], name: "index_rdblt_itfl", using: :btree
  add_index "rails_db_localize_translations", ["resource_id", "resource_type", "field"], name: "index_rdblt_itf", using: :btree
  add_index "rails_db_localize_translations", ["resource_id", "resource_type"], name: "index_rdblt_it", using: :btree
  add_index "rails_db_localize_translations", ["resource_id"], name: "index_rails_db_localize_translations_on_resource_id", using: :btree
  add_index "rails_db_localize_translations", ["resource_type"], name: "index_rails_db_localize_translations_on_resource_type", using: :btree

  create_table "translatables", force: :cascade do |t|
    t.string "name"
  end

end
