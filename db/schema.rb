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

ActiveRecord::Schema.define(:version => 20111221212734) do

  create_table "core_applications", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_machines", :force => true do |t|
    t.string   "host"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_backends", :force => true do |t|
    t.integer  "core_machine_id"
    t.integer  "core_application_id"
    t.string   "process"
    t.integer  "instance"
    t.integer  "port"
    t.datetime "last_seen_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_domain_rules", :force => true do |t|
    t.integer  "core_application_id"
    t.string   "domain"
    t.text     "actions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_passers", :force => true do |t|
    t.integer  "core_machine_id"
    t.integer  "port"
    t.datetime "last_seen_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_path_rules", :force => true do |t|
    t.integer  "core_application_id"
    t.string   "path"
    t.text     "actions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "http_routers", :force => true do |t|
    t.integer  "core_machine_id"
    t.integer  "port"
    t.datetime "last_seen_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
