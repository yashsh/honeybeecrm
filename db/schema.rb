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

ActiveRecord::Schema.define(:version => 20130515022422) do

  create_table "activities", :force => true do |t|
    t.integer  "contactid"
    t.integer  "userid"
    t.string   "name"
    t.string   "activitytype"
    t.string   "description"
    t.datetime "targetstart"
    t.datetime "targetfinish"
    t.datetime "actualstart"
    t.datetime "actualfinish"
    t.integer  "completeby"
    t.boolean  "bCompleted"
    t.boolean  "bDel"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "contact_logs", :force => true do |t|
    t.integer  "contactid"
    t.string   "contactname"
    t.string   "email"
    t.datetime "logdate"
    t.string   "logtype"
    t.string   "logdetail"
    t.boolean  "bSuccess"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "title"
    t.string   "organization"
    t.string   "phone"
    t.string   "altphone"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "saluation"
    t.string   "contacttype"
    t.string   "contactsource"
    t.string   "notes"
    t.boolean  "bClient"
    t.boolean  "bMentor"
    t.boolean  "bSendMail"
    t.boolean  "bDel"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "fbuser"
    t.string   "twuser"
    t.string   "liuser"
    t.string   "fbpic"
    t.string   "twpic"
    t.string   "lipic"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "email_templates", :force => true do |t|
    t.string   "name"
    t.string   "subject"
    t.string   "body"
    t.string   "emailtype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
