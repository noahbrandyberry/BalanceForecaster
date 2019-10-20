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

ActiveRecord::Schema.define(version: 2019_10_10_020116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name", default: "", null: false
    t.decimal "balance", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "inactive", default: false
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forecast_items", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.date "date"
    t.decimal "amount", precision: 8, scale: 2
    t.boolean "continues", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "new_date"
    t.boolean "deleted"
    t.string "name", default: ""
    t.boolean "is_bill", default: false
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.integer "user_id"
    t.string "name", default: "", null: false
    t.boolean "is_bill", default: false, null: false
    t.boolean "repeat", default: false, null: false
    t.integer "repeat_frequency"
    t.integer "repeat_type"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.boolean "is_transfer", default: false, null: false
    t.integer "transfer_id"
  end

  create_table "selected_items", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.integer "item_id"
    t.string "name"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "preferred_account"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "number"
    t.string "description"
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
