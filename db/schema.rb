# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_29_151858) do

  create_table "recipe_boxes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipe_id"
    t.string "recipe_note"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title"
    t.string "very_popular"
    t.string "very_healthy"
    t.string "vegetarian"
    t.string "source_url"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
  end

end
