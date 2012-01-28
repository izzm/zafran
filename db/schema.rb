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

ActiveRecord::Schema.define(:version => 20120128093146) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "attachments", :force => true do |t|
    t.integer  "resource_id",                           :null => false
    t.string   "resource_type",                         :null => false
    t.string   "name"
    t.string   "link"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image_fingerprint"
    t.boolean  "main",               :default => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "position"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "link"
    t.boolean  "visible"
    t.boolean  "virtual"
    t.string   "seo_title"
    t.string   "seo_keywords"
    t.string   "seo_description"
    t.text     "parameters"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_path",        :limit => 2000
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"
  add_index "categories", ["url_path"], :name => "index_categories_on_url_path"

  create_table "categories_goods", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "good_id"
  end

  add_index "categories_goods", ["category_id", "good_id"], :name => "index_categories_goods_on_category_id_and_good_id"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "clients", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "company"
    t.boolean  "corporate",                             :default => false
    t.date     "first_order"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["email"], :name => "index_clients_on_email", :unique => true
  add_index "clients", ["reset_password_token"], :name => "index_clients_on_reset_password_token", :unique => true

  create_table "customers", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "name"
    t.string   "company"
    t.boolean  "corporate",                             :default => false
    t.date     "first_order"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["email"], :name => "index_customers_on_email", :unique => true
  add_index "customers", ["reset_password_token"], :name => "index_customers_on_reset_password_token", :unique => true

  create_table "extra_attachments", :force => true do |t|
    t.integer  "resource_id",       :null => false
    t.string   "resource_type",     :null => false
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "goods", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category_id"
    t.integer  "position"
    t.integer  "price"
    t.text     "parameters"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "articul"
    t.text     "variants"
    t.text     "similar"
  end

  add_index "goods", ["category_id"], :name => "index_goods_on_category_id"

  create_table "order_goods", :force => true do |t|
    t.integer  "order_id"
    t.integer  "good_id"
    t.text     "variant"
    t.integer  "count"
    t.decimal  "price",      :precision => 8, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_goods", ["good_id"], :name => "index_order_goods_on_good_id"
  add_index "order_goods", ["order_id"], :name => "index_order_goods_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "customer_id"
    t.datetime "delivery_at"
    t.datetime "checked_out_at"
    t.boolean  "canceled"
    t.integer  "discount",                                     :default => 0
    t.decimal  "total_price",    :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number"
    t.string   "delivery_type"
    t.string   "address"
    t.text     "comment"
    t.string   "state"
  end

  add_index "orders", ["checked_out_at"], :name => "index_orders_on_checked_out_at"
  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "static_pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "parent_id"
    t.integer  "position"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "link"
    t.boolean  "visible"
    t.string   "seo_title"
    t.string   "seo_keywords"
    t.string   "seo_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url_path",        :limit => 2000
  end

  add_index "static_pages", ["parent_id"], :name => "index_static_pages_on_parent_id"
  add_index "static_pages", ["url_path"], :name => "index_static_pages_on_url_path"

  create_table "wishlist_goods", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "good_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wishlist_goods", ["customer_id"], :name => "index_wishlist_goods_on_customer_id"
  add_index "wishlist_goods", ["good_id"], :name => "index_wishlist_goods_on_good_id"

end
