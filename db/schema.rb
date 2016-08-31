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

ActiveRecord::Schema.define(version: 20160831225427) do

  create_table "assignment_problems", force: :cascade do |t|
    t.integer  "assignment_id", limit: 4
    t.integer  "problem_id",    limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "assignment_problems", ["assignment_id", "problem_id"], name: "index_assignment_problems_on_assignment_id_and_problem_id", unique: true, using: :btree
  add_index "assignment_problems", ["assignment_id"], name: "index_assignment_problems_on_assignment_id", using: :btree
  add_index "assignment_problems", ["problem_id"], name: "index_assignment_problems_on_problem_id", using: :btree

  create_table "assignments", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.text     "description", limit: 65535
    t.integer  "owner_id",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "course_assignments", force: :cascade do |t|
    t.integer  "course_id",     limit: 4
    t.integer  "assignment_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "course_assignments", ["assignment_id"], name: "index_course_assignments_on_assignment_id", using: :btree
  add_index "course_assignments", ["course_id", "assignment_id"], name: "index_course_assignments_on_course_id_and_assignment_id", unique: true, using: :btree
  add_index "course_assignments", ["course_id"], name: "index_course_assignments_on_course_id", using: :btree

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
    t.string   "name",                           limit: 255
    t.text     "statement",                      limit: 65535
    t.text     "input_format",                   limit: 65535
    t.text     "output_format",                  limit: 65535
    t.text     "examples",                       limit: 65535
    t.text     "notes",                          limit: 65535
    t.integer  "owner_id",                       limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.datetime "input_files_uploaded_at"
    t.datetime "outputs_generated_at"
    t.text     "outputs_generation_info",        limit: 65535
    t.boolean  "outputs_generation_in_progress"
    t.integer  "time_limit",                     limit: 4
  end

  create_table "student_portal_problem_solutions", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "course_id",     limit: 4
    t.integer  "assignment_id", limit: 4
    t.integer  "problem_id",    limit: 4
    t.text     "code",          limit: 65535
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.float    "grade",         limit: 24,    default: 0.0
    t.integer  "status",        limit: 4,     default: 0
  end

  add_index "student_portal_problem_solutions", ["assignment_id"], name: "index_student_portal_problem_solutions_on_assignment_id", using: :btree
  add_index "student_portal_problem_solutions", ["course_id"], name: "index_student_portal_problem_solutions_on_course_id", using: :btree
  add_index "student_portal_problem_solutions", ["problem_id"], name: "index_student_portal_problem_solutions_on_problem_id", using: :btree
  add_index "student_portal_problem_solutions", ["user_id", "course_id", "assignment_id", "problem_id"], name: "problem_solution_index", unique: true, using: :btree
  add_index "student_portal_problem_solutions", ["user_id"], name: "index_student_portal_problem_solutions_on_user_id", using: :btree

  create_table "student_portal_submissions", force: :cascade do |t|
    t.string   "language",            limit: 255
    t.integer  "status",              limit: 4,   default: 0
    t.integer  "problem_solution_id", limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "info",                limit: 255
    t.float    "grade",               limit: 24
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "time_limit",    limit: 4
    t.string   "language",      limit: 255
    t.string   "file_key",      limit: 255
    t.integer  "submission_id", limit: 4
    t.integer  "problem_id",    limit: 4
    t.string   "type",          limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "code",          limit: 65535
  end

  create_table "test_cases", force: :cascade do |t|
    t.integer  "problem_id", limit: 4
    t.integer  "weight",     limit: 4
    t.integer  "tc_index",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
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
