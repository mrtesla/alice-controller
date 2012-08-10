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

ActiveRecord::Schema.define(:version => 20120423152424) do

  create_table "core_applications", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "maintenance_mode",       :default => false
    t.boolean   "suspended_mode",         :default => false
    t.integer   "active_core_release_id"
  end

  add_index "core_applications", ["name"], :name => "index_core_applications_on_name"

  create_table "core_machines", :force => true do |t|
    t.string    "host"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "core_machines_core_releases", :id => false, :force => true do |t|
    t.integer "core_machine_id"
    t.integer "core_release_id"
  end

  create_table "core_releases", :force => true do |t|
    t.integer   "core_application_id"
    t.integer   "number"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "deploy_reference"
    t.string    "repository_reference"
  end

  create_table "http_backends", :force => true do |t|
    t.integer   "core_machine_id"
    t.integer   "core_application_id"
    t.string    "process"
    t.integer   "instance"
    t.integer   "port"
    t.timestamp "last_seen_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.timestamp "down_since"
    t.string    "error_message"
    t.string    "ui_name"
  end

  add_index "http_backends", ["core_application_id", "process", "instance"], :name => "app_process_instance_idx"
  add_index "http_backends", ["core_machine_id", "port"], :name => "index_http_backends_on_core_machine_id_and_port"
  add_index "http_backends", ["down_since"], :name => "index_http_backends_on_down_since"
  add_index "http_backends", ["port"], :name => "index_http_backends_on_port"

  create_table "http_domain_rules", :force => true do |t|
    t.integer   "core_application_id"
    t.string    "domain"
    t.text      "actions"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "http_passers", :force => true do |t|
    t.integer   "core_machine_id"
    t.integer   "port"
    t.timestamp "last_seen_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.timestamp "down_since"
    t.string    "error_message"
    t.string    "ui_name"
  end

  add_index "http_passers", ["core_machine_id", "port"], :name => "index_http_passers_on_core_machine_id_and_port"
  add_index "http_passers", ["down_since"], :name => "index_http_passers_on_down_since"
  add_index "http_passers", ["port"], :name => "index_http_passers_on_port"

  create_table "http_path_rules", :force => true do |t|
    t.integer   "owner_id"
    t.string    "path"
    t.text      "actions"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "static",     :default => false
    t.string    "owner_type"
  end

  add_index "http_path_rules", ["owner_id", "owner_type", "path"], :name => "owner_path"
  add_index "http_path_rules", ["owner_id", "owner_type"], :name => "owner"

  create_table "http_routers", :force => true do |t|
    t.integer   "core_machine_id"
    t.integer   "port"
    t.timestamp "last_seen_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.timestamp "down_since"
    t.string    "error_message"
    t.string    "ui_name"
  end

  add_index "http_routers", ["core_machine_id", "down_since", "port"], :name => "machine_down_port"
  add_index "http_routers", ["core_machine_id", "port"], :name => "index_http_routers_on_core_machine_id_and_port"
  add_index "http_routers", ["down_since", "port"], :name => "down_port"
  add_index "http_routers", ["down_since"], :name => "index_http_routers_on_down_since"
  add_index "http_routers", ["port"], :name => "index_http_routers_on_port"

  create_table "pluto_environment_variables", :force => true do |t|
    t.integer   "owner_id"
    t.string    "owner_type"
    t.string    "name"
    t.string    "value"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "pluto_process_definitions", :force => true do |t|
    t.integer   "owner_id"
    t.string    "owner_type"
    t.string    "name"
    t.integer   "concurrency", :default => 1
    t.string    "command"
    t.timestamp "created_at",                 :null => false
    t.timestamp "updated_at",                 :null => false
  end

  create_table "pluto_process_instances", :force => true do |t|
    t.integer  "pluto_process_definition_id"
    t.integer  "core_machine_id"
    t.integer  "instance"
    t.datetime "running_since"
    t.datetime "down_since"
    t.datetime "last_seen_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "users", :force => true do |t|
    t.string    "email",                                                :null => false
    t.string    "encrypted_password",     :limit => 128,                :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",                         :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
