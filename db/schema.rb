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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130401035106) do

  create_table "disciplines", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "disciplines", ["user_id"], :name => "index_disciplines_on_user_id"

  create_table "highlights", :force => true do |t|
    t.integer  "job_id"
    t.integer  "skill_id"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  add_index "highlights", ["job_id"], :name => "index_highlights_on_job_id"
  add_index "highlights", ["skill_id"], :name => "index_highlights_on_skill_id"
  add_index "highlights", ["user_id"], :name => "index_highlights_on_user_id"

  create_table "job_skills", :force => true do |t|
    t.integer  "job_id"
    t.integer  "skill_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  add_index "job_skills", ["job_id"], :name => "index_job_skills_on_job_id"
  add_index "job_skills", ["skill_id"], :name => "index_job_skills_on_skill_id"
  add_index "job_skills", ["user_id"], :name => "index_job_skills_on_user_id"

  create_table "job_softwares", :force => true do |t|
    t.integer  "job_id"
    t.integer  "software_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  add_index "job_softwares", ["job_id"], :name => "index_job_softwares_on_job_id"
  add_index "job_softwares", ["software_id"], :name => "index_job_softwares_on_software_id"
  add_index "job_softwares", ["user_id"], :name => "index_job_softwares_on_user_id"

  create_table "jobs", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "employer"
    t.integer  "start_month"
    t.integer  "start_year"
    t.integer  "end_month"
    t.integer  "end_year"
    t.string   "project"
    t.string   "url"
    t.string   "status"
    t.text     "short_desc"
    t.text     "long_desc"
    t.string   "reason"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "jobs", ["end_month"], :name => "index_jobs_on_end_month"
  add_index "jobs", ["end_year"], :name => "index_jobs_on_end_year"
  add_index "jobs", ["start_month"], :name => "index_jobs_on_start_month"
  add_index "jobs", ["start_year"], :name => "index_jobs_on_start_year"
  add_index "jobs", ["user_id"], :name => "index_jobs_on_user_id"

  create_table "links", :force => true do |t|
    t.date     "expiration"
    t.integer  "resume_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "hash"
  end

  create_table "login_validations", :force => true do |t|
    t.string   "hash"
    t.integer  "user_id"
    t.date     "expiration"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "resume_highlights", :force => true do |t|
    t.integer  "resume_id"
    t.integer  "highlight_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "resume_jobs", :force => true do |t|
    t.integer  "resume_id"
    t.integer  "job_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "resumes", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "resumes", ["user_id"], :name => "index_resumes_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "skills", :force => true do |t|
    t.string   "title"
    t.string   "abbreviation"
    t.string   "slug"
    t.integer  "rank"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "softwares", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.integer  "rank"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_skills", :force => true do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "discipline_id"
  end

  create_table "user_softwares", :force => true do |t|
    t.integer  "user_id"
    t.integer  "software_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "name"
    t.string   "address"
    t.text     "phone"
  end

end
