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

ActiveRecord::Schema.define(version: 20160223135605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "level"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "admins", ["name"], name: "index_admins_on_name", unique: true, using: :btree

  create_table "appointments", force: :cascade do |t|
    t.string   "appoint_unique_number"
    t.integer  "user_id"
    t.integer  "doctor_id"
    t.integer  "good_id"
    t.boolean  "finished",              default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "calender_id"
    t.string   "cellphone"
    t.boolean  "payed",                 default: false
    t.boolean  "canceled",              default: false
    t.string   "service_name"
    t.text     "service_description"
    t.float    "service_price"
    t.string   "calender_time"
    t.string   "calender_place"
    t.string   "calender_day"
    t.boolean  "cleared",               default: false
    t.boolean  "refunding",             default: false
    t.datetime "calender_datetime"
    t.boolean  "refunded",              default: false
    t.string   "refund_no"
  end

  create_table "attach_images", force: :cascade do |t|
    t.integer  "case_id"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calenders", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "doctor_id"
    t.string   "calender_day"
    t.string   "calender_place"
    t.integer  "calender_capacity"
    t.datetime "calender_start_time"
    t.datetime "calender_end_time"
    t.boolean  "published",           default: false
    t.integer  "calender_deal",       default: 0
    t.integer  "deal_appointment",    default: 0
  end

  add_index "calenders", ["calender_day"], name: "index_calenders_on_calender_day", using: :btree

  create_table "cases", force: :cascade do |t|
    t.string   "symptom"
    t.string   "check"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "appointment_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "appointment_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "doctor_id"
    t.boolean  "checked",        default: false
    t.boolean  "approved",       default: true
    t.text     "content"
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "doctors_count", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "departments_doctors", id: false, force: :cascade do |t|
    t.integer "doctor_id",     null: false
    t.integer "department_id", null: false
  end

  add_index "departments_doctors", ["department_id"], name: "index_departments_doctors_on_department_id", using: :btree
  add_index "departments_doctors", ["doctor_id"], name: "index_departments_doctors_on_doctor_id", using: :btree

  create_table "doctors", force: :cascade do |t|
    t.string   "name"
    t.string   "openid"
    t.text     "description"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "published",          default: false
    t.integer  "hospital_id"
    t.integer  "grade_id"
    t.integer  "appointments_count", default: 0
    t.integer  "comments_count",     default: 0
    t.integer  "ratings_count",      default: 0
  end

  add_index "doctors", ["name"], name: "index_doctors_on_name", using: :btree

  create_table "doctors_skills", id: false, force: :cascade do |t|
    t.integer "doctor_id", null: false
    t.integer "skill_id",  null: false
  end

  add_index "doctors_skills", ["doctor_id"], name: "index_doctors_skills_on_doctor_id", using: :btree
  add_index "doctors_skills", ["skill_id"], name: "index_doctors_skills_on_skill_id", using: :btree

  create_table "goods", force: :cascade do |t|
    t.integer  "doctor_id"
    t.float    "price"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "name"
    t.text     "description"
    t.boolean  "published",   default: false
  end

  add_index "goods", ["name"], name: "index_goods_on_name", using: :btree

  create_table "goods_tags", id: false, force: :cascade do |t|
    t.integer "tag_id",  null: false
    t.integer "good_id", null: false
  end

  create_table "grades", force: :cascade do |t|
    t.string   "name"
    t.integer  "doctors_count", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "hospitals", force: :cascade do |t|
    t.string   "name"
    t.integer  "doctors_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incomes", force: :cascade do |t|
    t.integer  "doctor_id"
    t.float    "number"
    t.string   "user_openid"
    t.string   "appointment_no"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "places", force: :cascade do |t|
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "doctor_id"
  end

  create_table "predoctors", force: :cascade do |t|
    t.string   "name"
    t.string   "openid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "attitude"
    t.integer  "professional"
    t.integer  "statisfication"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id"
    t.integer  "doctor_id"
    t.integer  "appointment_id"
    t.boolean  "approved",       default: true
  end

  add_index "ratings", ["appointment_id"], name: "index_ratings_on_appointment_id", using: :btree
  add_index "ratings", ["doctor_id"], name: "index_ratings_on_doctor_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "openid"
    t.string   "name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "subscribe"
    t.string   "avatar"
    t.integer  "appointments_count", default: 0
    t.integer  "comments_count",     default: 0
    t.integer  "ratings_count",      default: 0
    t.string   "nickname"
  end

  add_index "users", ["openid"], name: "index_users_on_openid", unique: true, using: :btree

  create_table "withdraws", force: :cascade do |t|
    t.integer  "doctor_id"
    t.float    "number"
    t.string   "operator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
