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

ActiveRecord::Schema.define(version: 2021_08_03_043949) do

  create_table "mymenus", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category_id", null: false
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mymenus_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "mymenus", "users"
end
