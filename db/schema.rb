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

ActiveRecord::Schema.define(version: 20190521063238) do

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "model_id",   limit: 4
    t.string   "model_type", limit: 255
    t.string   "path",       limit: 255
    t.string   "file_name",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "model_id",    limit: 4
    t.string   "model_type",  limit: 255
    t.string   "from_status", limit: 255
    t.string   "to_status",   limit: 255
    t.string   "content",     limit: 255
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "desc",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "instance_categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "instance_logs", force: :cascade do |t|
    t.integer  "instance_id", limit: 4
    t.string   "file_name",   limit: 255
    t.string   "file_path",   limit: 255
    t.integer  "user_id",     limit: 4
    t.string   "status",      limit: 255
    t.datetime "active_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.datetime "apply_at"
    t.integer  "develop_id",  limit: 4
    t.integer  "flow_id",     limit: 4
    t.integer  "active_id",   limit: 4
  end

  create_table "instance_organizations", force: :cascade do |t|
    t.integer  "instance_id",     limit: 4
    t.integer  "organization_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "instances", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "instance_no",          limit: 255
    t.string   "color",                limit: 255
    t.string   "norms",                limit: 255
    t.string   "file_name",            limit: 255
    t.string   "file_path",            limit: 255
    t.text     "desc",                 limit: 65535
    t.integer  "user_id",              limit: 4
    t.integer  "last_user_id",         limit: 4
    t.datetime "last_updated_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "file_user_id",         limit: 4
    t.datetime "active_at"
    t.integer  "technology_id",        limit: 4
    t.string   "ancestry",             limit: 255
    t.integer  "instance_category_id", limit: 4
  end

  add_index "instances", ["ancestry"], name: "index_instances_on_ancestry", using: :btree

  create_table "instances_users", force: :cascade do |t|
    t.integer  "instance_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "matters", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.text     "desc",                limit: 65535
    t.integer  "user_id",             limit: 4
    t.integer  "file_user_id",        limit: 4
    t.datetime "last_update_at"
    t.string   "file_path",           limit: 255
    t.string   "file_name",           limit: 255
    t.boolean  "agree"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "status",              limit: 255,   default: "circulation"
    t.integer  "countersign_user_id", limit: 4
    t.datetime "countersign_at"
  end

  create_table "notices", force: :cascade do |t|
    t.integer  "model_id",   limit: 4
    t.string   "model_type", limit: 255
    t.text     "content",    limit: 65535
    t.boolean  "need_reply"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title",      limit: 255
    t.integer  "user_id",    limit: 4
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "desc",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "ancestry",   limit: 255
  end

  add_index "organizations", ["ancestry"], name: "index_organizations_on_ancestry", using: :btree

  create_table "product_logs", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.string   "file_name",  limit: 255
    t.string   "file_path",  limit: 255
    t.integer  "user_id",    limit: 4
    t.string   "status",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "active_at"
    t.datetime "apply_at"
    t.integer  "develop_id", limit: 4
    t.integer  "flow_id",    limit: 4
    t.integer  "active_id",  limit: 4
  end

  create_table "product_organizations", force: :cascade do |t|
    t.integer  "product_id",      limit: 4
    t.integer  "organization_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "category_id",     limit: 4
    t.string   "name",            limit: 255
    t.string   "product_no",      limit: 255
    t.string   "color",           limit: 255
    t.string   "norms",           limit: 255
    t.string   "file_name",       limit: 255
    t.string   "file_path",       limit: 255
    t.text     "desc",            limit: 65535
    t.integer  "user_id",         limit: 4
    t.integer  "last_user_id",    limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "last_updated_at"
    t.integer  "file_user_id",    limit: 4
    t.datetime "active_at"
    t.integer  "technology_id",   limit: 4
  end

  create_table "products_instances", force: :cascade do |t|
    t.integer  "product_id",  limit: 4
    t.integer  "instance_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "products_users", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "action",     limit: 255
    t.string   "target",     limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "role_resources", force: :cascade do |t|
    t.integer  "role_id",     limit: 4
    t.integer  "resource_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "desc",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "technologies", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "no",           limit: 255
    t.string   "name",         limit: 255
    t.datetime "valid_at"
    t.text     "desc",         limit: 65535
    t.string   "file_name",    limit: 255
    t.string   "file_path",    limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "last_user_id", limit: 4
    t.integer  "file_user_id", limit: 4
    t.datetime "active_at"
  end

  create_table "technology_instances", force: :cascade do |t|
    t.integer  "technology_id", limit: 4
    t.integer  "instance_id",   limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "technology_logs", force: :cascade do |t|
    t.integer  "technology_id", limit: 4
    t.string   "file_name",     limit: 255
    t.string   "file_path",     limit: 255
    t.integer  "user_id",       limit: 4
    t.string   "status",        limit: 255
    t.integer  "develop_id",    limit: 4
    t.integer  "flow_id",       limit: 4
    t.integer  "active_id",     limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "active_at"
    t.datetime "apply_at"
  end

  create_table "user_matters", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "matter_id",  limit: 4
    t.boolean  "agree"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "user_notices", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "notice_id",  limit: 4
    t.text     "reply",      limit: 65535
    t.boolean  "readed"
    t.boolean  "replied"
    t.datetime "replied_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "login",                  limit: 255
    t.string   "name",                   limit: 255
    t.integer  "role_id",                limit: 4
    t.integer  "organization_id",        limit: 4
    t.string   "phone",                  limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 191,        null: false
    t.integer  "item_id",    limit: 4,          null: false
    t.string   "event",      limit: 255,        null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
