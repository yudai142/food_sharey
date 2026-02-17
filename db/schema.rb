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

ActiveRecord::Schema[7.0].define(version: 2022_06_30_040456) do
  create_table "eatdate_likes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "eatdate_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["eatdate_id"], name: "index_eatdate_likes_on_eatdate_id"
    t.index ["user_id"], name: "index_eatdate_likes_on_user_id"
  end

  create_table "eatdates", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.date "date", null: false
    t.integer "timezone", null: false
    t.time "eat_time"
    t.text "comment"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_eatdates_on_date"
    t.index ["timezone"], name: "index_eatdates_on_timezone"
    t.index ["user_id"], name: "index_eatdates_on_user_id"
  end

  create_table "foods", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "image"
    t.integer "mymenu_id"
    t.integer "calorie"
    t.integer "protein"
    t.integer "fat"
    t.integer "carbohydrate"
    t.integer "sugar"
    t.integer "dietary_fiber"
    t.integer "salt"
    t.integer "Vitamin_A"
    t.integer "Vitamin_D"
    t.integer "Vitamin_E"
    t.integer "Vitamin_B1"
    t.integer "Vitamin_B2"
    t.integer "Vitamin_B6"
    t.integer "Vitamin_B12"
    t.integer "Vitamin_C"
    t.integer "potassium"
    t.integer "calcium"
    t.integer "magnesium"
    t.integer "iron"
    t.bigint "eatdate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["eatdate_id"], name: "index_foods_on_eatdate_id"
  end

  create_table "mymenu_likes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "mymenu_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mymenu_id"], name: "index_mymenu_likes_on_mymenu_id"
    t.index ["user_id"], name: "index_mymenu_likes_on_user_id"
  end

  create_table "mymenus", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category_id"
    t.string "image"
    t.integer "calorie"
    t.integer "protein"
    t.integer "fat"
    t.integer "carbohydrate"
    t.integer "sugar"
    t.integer "dietary_fiber"
    t.integer "salt"
    t.integer "Vitamin_A"
    t.integer "Vitamin_D"
    t.integer "Vitamin_E"
    t.integer "Vitamin_B1"
    t.integer "Vitamin_B2"
    t.integer "Vitamin_B6"
    t.integer "Vitamin_B12"
    t.integer "Vitamin_C"
    t.integer "potassium"
    t.integer "calcium"
    t.integer "magnesium"
    t.integer "iron"
    t.string "memo"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_mymenus_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "food_ideas_hide", default: false
    t.boolean "user_ranking_hide", default: false
    t.boolean "release", default: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end

  add_foreign_key "eatdate_likes", "eatdates"
  add_foreign_key "eatdate_likes", "users"
  add_foreign_key "eatdates", "users"
  add_foreign_key "foods", "eatdates"
  add_foreign_key "mymenu_likes", "mymenus"
  add_foreign_key "mymenu_likes", "users"
  add_foreign_key "mymenus", "users"
end
