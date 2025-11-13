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

ActiveRecord::Schema[8.1].define(version: 2025_11_13_000258) do
  create_table "searches", force: :cascade do |t|
    t.string "buying_options"
    t.string "category_ids"
    t.string "condition_ids"
    t.string "conditions"
    t.datetime "created_at", null: false
    t.boolean "disabled", default: false
    t.string "excluded_category_ids"
    t.text "excluded_sellers"
    t.integer "maximum_cents"
    t.integer "minimum_cents"
    t.string "name"
    t.text "notes"
    t.string "price_currency"
    t.text "query"
    t.boolean "search_in_description"
    t.text "sellers"
    t.datetime "updated_at", null: false
  end
end
