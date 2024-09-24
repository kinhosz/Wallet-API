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

ActiveRecord::Schema[7.0].define(version: 2024_09_20_011514) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "finance_categories", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.text "description", default: "", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.index ["user_id"], name: "index_finance_categories_on_user_id"
  end

  create_table "finance_planning_lines", force: :cascade do |t|
    t.decimal "value"
    t.bigint "finance_planning_id"
    t.bigint "finance_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finance_category_id"], name: "index_finance_planning_lines_on_finance_category_id"
    t.index ["finance_planning_id"], name: "index_finance_planning_lines_on_finance_planning_id"
  end

  create_table "finance_plannings", force: :cascade do |t|
    t.date "date_start", null: false
    t.date "date_end"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency", default: "BRL", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.index ["user_id"], name: "index_finance_plannings_on_user_id"
  end

  create_table "finance_transactions", force: :cascade do |t|
    t.text "description", default: "", null: false
    t.date "occurred_at", null: false
    t.decimal "value", null: false
    t.bigint "finance_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency", default: "BRL", null: false
    t.index ["finance_category_id"], name: "index_finance_transactions_on_finance_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "finance_categories", "users"
  add_foreign_key "finance_planning_lines", "finance_categories"
  add_foreign_key "finance_planning_lines", "finance_plannings"
  add_foreign_key "finance_plannings", "users"
  add_foreign_key "finance_transactions", "finance_categories"
end
