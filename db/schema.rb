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

ActiveRecord::Schema.define(version: 20160720021121) do

  create_table "course_students", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "course_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "course_students", ["course_id"], name: "index_course_students_on_course_id", using: :btree
  add_index "course_students", ["user_id", "course_id"], name: "index_course_students_on_user_id_and_course_id", unique: true, using: :btree
  add_index "course_students", ["user_id"], name: "index_course_students_on_user_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "owner_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "problems", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.text     "statement",               limit: 65535
    t.text     "input_format",            limit: 65535
    t.text     "output_format",           limit: 65535
    t.text     "examples",                limit: 65535
    t.text     "notes",                   limit: 65535
    t.integer  "owner_id",                limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "input_files_uploaded_at"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "time_limit",    limit: 4
    t.string   "language",      limit: 255
    t.string   "file_key",      limit: 255
    t.integer  "submission_id", limit: 4
    t.integer  "problem_id",    limit: 4
    t.string   "type",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "user_connections", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "connection_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "user_connections", ["connection_id"], name: "index_user_connections_on_connection_id", using: :btree
  add_index "user_connections", ["user_id", "connection_id"], name: "index_user_connections_on_user_id_and_connection_id", unique: true, using: :btree
  add_index "user_connections", ["user_id"], name: "index_user_connections_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "email",             limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "password_digest",   limit: 255
    t.string   "remember_digest",   limit: 255
    t.boolean  "admin"
    t.string   "activation_digest", limit: 255
    t.boolean  "activated",                     default: false
    t.datetime "activated_at"
    t.string   "connection_token",  limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
