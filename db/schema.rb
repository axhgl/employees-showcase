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

ActiveRecord::Schema[7.0].define(version: 2023_03_17_185034) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.integer "employees_count", default: 0, null: false
    t.integer "departments_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "company_addresses", force: :cascade do |t|
    t.string "street", null: false
    t.string "city"
    t.point "coordinates", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_addresses_on_company_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_departments_on_company_id"
    t.index ["name", "company_id"], name: "unique_company_department_names", unique: true
  end

  create_table "employee_addresses", force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.point "coordinates"
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_addresses_on_employee_id"
  end

  create_table "employee_bank_informations", force: :cascade do |t|
    t.string "card_expiration"
    t.string "card_number"
    t.string "card_type"
    t.string "currency"
    t.string "iban"
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_employee_bank_informations_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "full_name", null: false
    t.string "email", null: false
    t.integer "age", null: false
    t.string "gender", default: "female", null: false
    t.integer "height", null: false
    t.float "weight"
    t.string "image"
    t.jsonb "hair", default: {}
    t.inet "ip"
    t.string "job_title", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["full_name"], name: "index_employees_on_full_name", unique: true
  end

  add_foreign_key "company_addresses", "companies"
  add_foreign_key "departments", "companies"
  add_foreign_key "employee_addresses", "employees"
  add_foreign_key "employee_bank_informations", "employees"
  add_foreign_key "employees", "companies"
end
