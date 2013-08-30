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

ActiveRecord::Schema.define(:version => 20130828073315) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "organization_id"
    t.string   "deleted_name"
  end

  add_index "activities", ["organization_id"], :name => "index_activities_on_organization_id"
  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "appointment_recurrings", :force => true do |t|
    t.string   "repeat_type"
    t.string   "repeat_every"
    t.boolean  "date_mon",       :default => false
    t.boolean  "date_tue",       :default => false
    t.boolean  "date_wed",       :default => false
    t.boolean  "date_thu",       :default => false
    t.boolean  "date_fri",       :default => false
    t.boolean  "date_sat",       :default => false
    t.boolean  "date_sun",       :default => false
    t.integer  "time_to_repeat"
    t.date     "end_date"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "appointments", :force => true do |t|
    t.integer  "staff_id"
    t.integer  "organization_id"
    t.datetime "appointment_date"
    t.boolean  "is_locked",                                              :default => false
    t.string   "status"
    t.integer  "created_by"
    t.integer  "appointment_recurring_id"
    t.string   "appointment_unique_id"
    t.integer  "service_id"
    t.decimal  "cost",                     :precision => 2, :scale => 0, :default => 0
    t.time     "appointment_time"
    t.time     "time"
    t.time     "duration"
    t.string   "first_name",                                             :default => ""
    t.string   "last_name",                                              :default => ""
    t.string   "gender",                                                 :default => ""
    t.string   "email",                                                  :default => ""
    t.string   "state",                                                  :default => ""
    t.string   "city",                                                   :default => ""
    t.string   "address",                                                :default => ""
    t.string   "postal_code",                                            :default => ""
    t.string   "country",                                                :default => ""
    t.string   "phone",                                                  :default => ""
    t.string   "note",                                                   :default => ""
    t.integer  "customer_id",                                            :default => 0
    t.datetime "created_at",                                                                :null => false
    t.datetime "updated_at",                                                                :null => false
  end

  create_table "billing_infos", :force => true do |t|
    t.integer  "user_id"
    t.string   "state"
    t.string   "city"
    t.string   "address"
    t.string   "postal_code"
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "card_infos", :force => true do |t|
    t.integer  "user_id"
    t.string   "card_type"
    t.string   "card_number"
    t.string   "expiration_month"
    t.string   "expiration_year"
    t.string   "cvv"
    t.string   "card_holder_name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "customers", :force => true do |t|
    t.integer  "organization_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "email"
    t.string   "state"
    t.string   "city"
    t.string   "address"
    t.string   "postal_code"
    t.string   "country"
    t.string   "phone"
    t.string   "note"
    t.date     "date_of_birth"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
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

  create_table "features", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "status",      :default => true
    t.integer  "order"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "features_pricing_plans", :force => true do |t|
    t.integer  "feature_id"
    t.integer  "pricing_plan_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.boolean  "is_super_org",    :default => false
    t.string   "description"
    t.string   "language",        :default => "en"
    t.string   "time_zone",       :default => ""
    t.date     "expired_date"
    t.boolean  "is_monthly_paid", :default => false
    t.boolean  "is_stopped",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",           :default => ""
    t.string   "city",            :default => ""
    t.string   "address",         :default => ""
    t.string   "country",         :default => ""
    t.string   "phone",           :default => ""
    t.integer  "pricing_plan_id", :default => 0
    t.string   "subdomain"
  end

  create_table "payment_histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "pricing_plan_id"
    t.float    "total_paid"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "note",            :default => ""
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "group_permission_name"
  end

  create_table "pricing_plans", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "status",           :default => true
    t.float    "price_per_month"
    t.integer  "number_of_stores"
    t.integer  "user_staff"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "service_staffs", :force => true do |t|
    t.integer  "service_id"
    t.string   "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "services", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_active",       :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "organization_id"
  end

  add_index "user_groups", ["organization_id"], :name => "index_user_groups_on_organization_id"

  create_table "user_groups_permissions", :force => true do |t|
    t.integer  "user_group_id"
    t.integer  "permission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_groups_users", :force => true do |t|
    t.integer  "user_group_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "",    :null => false
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
    t.boolean  "is_admin",               :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_deleted",             :default => false
    t.string   "email"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "organization_id"
  end

  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
