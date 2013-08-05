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

ActiveRecord::Schema.define(:version => 20130805015142) do

  create_table "cms_files", :force => true do |t|
    t.integer  "cms_user_id"
    t.string   "image"
    t.string   "title"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "cms_files", ["cms_user_id"], :name => "index_cms_files_on_cms_user_id"

  create_table "cms_navigations", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.string   "link_title"
    t.integer  "position",   :default => 0
    t.boolean  "is_hidden",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "cms_navigations", ["is_hidden"], :name => "index_cms_navigations_on_is_hidden"

  create_table "cms_pages", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "author_id"
    t.integer  "sidebar_id"
    t.integer  "position",           :default => 0
    t.integer  "children_count",     :default => 0
    t.string   "title"
    t.boolean  "is_displayed_title", :default => true
    t.string   "slug"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.text     "content"
    t.boolean  "is_published",       :default => true
    t.integer  "old_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "meta_title"
    t.string   "redirect_path"
  end

  add_index "cms_pages", ["author_id"], :name => "index_cms_pages_on_author_id"
  add_index "cms_pages", ["is_displayed_title"], :name => "index_cms_pages_on_is_displayed_title"
  add_index "cms_pages", ["is_published"], :name => "index_cms_pages_on_is_published"
  add_index "cms_pages", ["parent_id"], :name => "index_cms_pages_on_parent_id"
  add_index "cms_pages", ["sidebar_id"], :name => "index_cms_pages_on_sidebar_id"
  add_index "cms_pages", ["slug"], :name => "index_cms_pages_on_slug"

  create_table "cms_settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "cms_settings", ["key"], :name => "index_cms_settings_on_key", :unique => true

  create_table "cms_sidebars", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cms_users", :force => true do |t|
    t.string   "nickname"
    t.boolean  "is_admin",               :default => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "cms_users", ["email"], :name => "index_cms_users_on_email", :unique => true
  add_index "cms_users", ["reset_password_token"], :name => "index_cms_users_on_reset_password_token", :unique => true

end
