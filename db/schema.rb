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

ActiveRecord::Schema.define(:version => 20140812055250) do

  create_table "account_email_lists", :force => true do |t|
    t.integer "account_id"
    t.string  "list_id"
  end

  create_table "account_preferences", :force => true do |t|
    t.string   "preference_type"
    t.integer  "vendor_id"
    t.string   "cuisine"
    t.text     "disposition"
    t.integer  "account_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "account_pricing_tiers", :force => true do |t|
    t.string   "product"
    t.integer  "account_id"
    t.integer  "pricing_tier_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "account_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "role",       :default => "member"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "account_roles", ["account_id"], :name => "index_account_roles_on_account_id"
  add_index "account_roles", ["user_id"], :name => "index_account_roles_on_user_id"

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "website"
    t.string   "account_type"
    t.boolean  "active",                    :default => true
    t.integer  "address_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "account_exec_id"
    t.integer  "sales_rep_id"
    t.integer  "account_manager_id"
    t.string   "credit_status",             :default => "Prepay"
    t.decimal  "credit_limit",              :default => 0.0
    t.integer  "net_days_for_full_payment", :default => 30
    t.integer  "buffer_days",               :default => 10
    t.boolean  "tax_exempt",                :default => false,    :null => false
    t.boolean  "active_popup_vouchers",     :default => true
  end

  create_table "accounts_buildings", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "building_id"
  end

  create_table "addresses", :force => true do |t|
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
  end

  create_table "assets", :force => true do |t|
    t.string   "description"
    t.string   "resource_file_name"
    t.string   "resource_content_type"
    t.integer  "resource_file_size"
    t.datetime "resource_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.boolean  "is_default",            :default => false
  end

  create_table "billing_references", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.integer  "event_id"
    t.boolean  "required",   :default => false
    t.text     "data"
    t.datetime "deleted_at"
  end

  create_table "braintree_accounts", :force => true do |t|
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "braintree_id"
  end

  create_table "building_documents", :force => true do |t|
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.integer  "building_id"
    t.integer  "user_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "buildings", :force => true do |t|
    t.string  "name"
    t.boolean "insurance_required"
    t.string  "insurance_requirements", :limit => 1000
    t.string  "parking_information",    :limit => 1000
    t.string  "loading_information",    :limit => 1000
    t.string  "site_directions",        :limit => 1000
    t.integer "market_id"
    t.integer "address_id"
    t.string  "contact_title"
    t.string  "contact_name"
    t.string  "contact_phone"
    t.string  "contact_cell"
    t.string  "contact_fax"
    t.string  "contact_email"
    t.string  "timezone"
    t.boolean "is_approved",                            :default => false
  end

  create_table "capacities", :force => true do |t|
    t.integer  "day"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "is_closed",  :default => false
    t.integer  "vendor_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "cards", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "nickname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "account_id"
  end

  create_table "catering_billings", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.integer  "user_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "credit_card_name"
    t.string   "credit_card_type"
    t.string   "credit_card_last_4"
    t.string   "credit_card_expense_code"
  end

  create_table "catering_contacts", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "catering_orders", :force => true do |t|
    t.string   "zipcode"
    t.string   "guest_count"
    t.datetime "event_date"
    t.text     "event_notes"
    t.integer  "user_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "billing_reference_id"
    t.integer  "location_id"
    t.integer  "contact_id"
    t.integer  "total"
    t.integer  "event_id"
    t.integer  "account_id"
    t.text     "order_builder_dump"
    t.boolean  "event_supplies",       :default => true
    t.integer  "tax"
    t.string   "order_type",           :default => "catering"
  end

  add_index "catering_orders", ["account_id"], :name => "index_lunchbox_orders_on_account_id"
  add_index "catering_orders", ["user_id"], :name => "index_lunchbox_orders_on_user_id"

  create_table "catering_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "catering_sessions", ["session_id"], :name => "index_lunchbox_sessions_on_session_id"
  add_index "catering_sessions", ["updated_at"], :name => "index_lunchbox_sessions_on_updated_at"

  create_table "catering_shippings", :force => true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "description"
    t.integer  "issue_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "comments", ["issue_id"], :name => "index_comments_on_issue_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "position"
    t.string   "email"
    t.string   "phone_number"
    t.string   "mobile_number"
    t.string   "fax_number"
    t.boolean  "primary_contact"
    t.boolean  "billing_notifications"
    t.boolean  "event_notifications"
    t.boolean  "sms"
    t.integer  "account_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.integer  "vendor_id"
    t.boolean  "feedback_notifications", :default => true
    t.integer  "user_id"
    t.string   "contact_type",           :default => "Internal"
    t.boolean  "self_created",           :default => false
    t.datetime "deleted_at"
  end

  create_table "default_billing_references", :force => true do |t|
    t.integer  "user_id"
    t.integer  "billing_reference_id"
    t.string   "choice"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "default_billing_references", ["billing_reference_id"], :name => "index_default_billing_references_on_billing_reference_id"
  add_index "default_billing_references", ["user_id"], :name => "index_default_billing_references_on_user_id"

  create_table "delivery_groups", :force => true do |t|
    t.string  "name"
    t.text    "location_ids"
    t.integer "user_id"
  end

  create_table "documents", :force => true do |t|
    t.string   "document_type"
    t.string   "recipient"
    t.string   "total"
    t.integer  "event_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "status"
    t.string   "name"
    t.string   "full_file_name"
    t.integer  "creator_id"
    t.integer  "voucher_group_id"
  end

  create_table "emails", :force => true do |t|
    t.string   "email"
    t.string   "email_list"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_managed_services_rollups", :force => true do |t|
    t.integer  "revenue_cents"
    t.integer  "cogs_cents"
    t.integer  "delivery_charge_to_vendor_cents"
    t.integer  "total_billing_cents"
    t.integer  "total_tax_cents"
    t.integer  "subtotal_cents"
    t.integer  "gratuity_cents"
    t.integer  "enterprise_fee_cents"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "delivery_charge_to_account_cents"
    t.integer  "vouchers_purchased_cents"
  end

  create_table "event_schedules", :force => true do |t|
    t.string   "schedule"
    t.string   "product"
    t.string   "meal_period"
    t.integer  "location_id"
    t.integer  "days_to_schedule"
    t.integer  "contact_id"
    t.integer  "vendor_id"
    t.integer  "account_id"
    t.datetime "event_start_time"
    t.datetime "event_end_time"
    t.datetime "setup_start_time"
    t.datetime "setup_end_time"
    t.datetime "schedule_start_date"
    t.datetime "schedule_end_date"
    t.datetime "pause_start_date"
    t.datetime "pause_end_date"
    t.datetime "processed_until"
    t.integer  "created_by_id"
    t.integer  "menu_template_id"
    t.integer  "quantity"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "event_schedule_owner_id"
  end

  create_table "event_transaction_methods", :force => true do |t|
    t.string  "transaction_method"
    t.string  "info1"
    t.string  "info2"
    t.string  "transaction_card_token"
    t.integer "user_id"
    t.string  "party_type"
    t.integer "party_id"
  end

  create_table "event_transactions", :force => true do |t|
    t.integer  "event_id"
    t.string   "transaction_id"
    t.string   "status"
    t.float    "amount"
    t.string   "transaction_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "event_transactions", ["event_id"], :name => "index_event_transactions_on_event_id"

  create_table "event_vendors", :force => true do |t|
    t.integer  "event_id"
    t.integer  "vendor_id"
    t.integer  "participation"
    t.integer  "menu_template_id"
    t.string   "pricing_type"
    t.integer  "default_menu_cogs_cents"
    t.integer  "default_menu_sell_price_cents"
    t.integer  "default_menu_retail_price_cents"
    t.text     "external_vendor_notes"
    t.integer  "event_transaction_method_id"
    t.datetime "vendor_billing_summary_sent_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "meal_period"
    t.integer  "account_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "quantity"
    t.string   "product",                          :limit => 30
    t.string   "menu_name"
    t.string   "status"
    t.integer  "contact_id"
    t.string   "service_style"
    t.boolean  "individual_label"
    t.boolean  "utensils_plates_napkins"
    t.boolean  "serving_utensils"
    t.boolean  "sternos"
    t.boolean  "chaffing_frames"
    t.text     "internal_event_notes"
    t.text     "external_account_notes"
    t.text     "building_instructions"
    t.text     "location_instructions"
    t.integer  "location_id"
    t.integer  "event_transaction_method_id"
    t.datetime "event_start_time"
    t.datetime "event_end_time"
    t.datetime "setup_start_time"
    t.datetime "setup_end_time"
    t.integer  "created_by_id"
    t.integer  "event_schedule_id"
    t.datetime "event_start_time_utc"
    t.datetime "event_end_time_utc"
    t.datetime "setup_start_time_utc"
    t.datetime "setup_end_time_utc"
    t.integer  "event_managed_services_rollup_id"
    t.string   "cancellation_reason"
    t.boolean  "canceled_within_24_hours",                       :default => false, :null => false
    t.string   "feedback_status"
    t.datetime "feedback_updated_at"
    t.integer  "duplicated_from_event_id"
    t.integer  "event_owner_id"
    t.datetime "claimed_at"
  end

  create_table "inventory_item_product_types", :force => true do |t|
    t.integer "inventory_item_id"
    t.string  "product_type",      :limit => 20
  end

  create_table "inventory_items", :force => true do |t|
    t.string   "name_vendor"
    t.text     "description"
    t.string   "sku"
    t.boolean  "featured"
    t.string   "type"
    t.string   "image"
    t.integer  "vendor_id"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.string   "meal_type",             :limit => 20
    t.integer  "cogs_cents"
    t.integer  "perks_price_cents"
    t.integer  "retail_price_cents"
    t.string   "name_public"
    t.integer  "premium_price_cents",                 :default => 0,              :null => false
    t.boolean  "inventory_item_option",               :default => false,          :null => false
    t.integer  "min_feeds",                           :default => 1
    t.integer  "max_feeds"
    t.string   "packaging_details",                   :default => "Family Style"
    t.integer  "min_quantity",                        :default => 0,              :null => false
    t.boolean  "eligible_for_add_ons"
  end

  create_table "inventory_items_option_groups", :id => false, :force => true do |t|
    t.integer "inventory_item_id"
    t.integer "option_group_id"
  end

  create_table "issues", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "priority"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "assignee_id"
    t.integer  "assigner_id"
    t.datetime "open_date"
    t.datetime "due_date"
    t.boolean  "status",       :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "line_item_types", :force => true do |t|
    t.string   "line_item_type"
    t.string   "line_item_sub_type"
    t.string   "sku"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "line_items", :force => true do |t|
    t.string  "line_item_type"
    t.string  "sku"
    t.string  "name"
    t.text    "notes"
    t.integer "quantity"
    t.boolean "include_price_in_expense"
    t.boolean "include_price_in_revenue"
    t.integer "event_id"
    t.integer "inventory_item_id"
    t.string  "billable_party_type"
    t.integer "billable_party_id"
    t.string  "payable_party_type"
    t.integer "payable_party_id"
    t.decimal "tax_rate_expense"
    t.decimal "tax_rate_revenue"
    t.string  "line_item_sub_type"
    t.boolean "after_subtotal"
    t.boolean "percentage_of_subtotal"
    t.integer "document_id"
    t.integer "unit_price_expense_cents"
    t.integer "unit_price_revenue_cents"
    t.integer "parent_id"
    t.integer "menu_template_id"
    t.boolean "tax_rate_default_locked_expense", :default => false, :null => false
    t.boolean "tax_rate_default_locked_revenue", :default => false, :null => false
    t.integer "add_on_parent_id"
    t.integer "opposing_line_item_id"
  end

  create_table "location_documents", :force => true do |t|
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.integer  "location_id"
    t.integer  "user_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "location_type"
    t.integer  "expected_participation"
    t.string   "privacy"
    t.text     "service_event_instructions"
    t.text     "connectivity_instructions"
    t.text     "delivery_event_instructions"
    t.string   "building_address_notes"
    t.integer  "contact_id"
    t.integer  "account_id"
    t.integer  "building_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "created_by_id"
    t.datetime "deleted_at"
    t.integer  "deleted_by_id"
    t.integer  "default_site_fee_cents"
  end

  create_table "markets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.decimal  "default_tax_rate",     :default => 10.5, :null => false
    t.string   "office_default_phone"
    t.string   "office_default_fax"
    t.string   "office_default_email"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "office_default_sms"
  end

  create_table "markets_zip_codes", :id => false, :force => true do |t|
    t.integer "market_id"
    t.integer "zip_code_id"
  end

  create_table "menu_level_discounts", :force => true do |t|
    t.integer "min_participation"
    t.integer "menu_template_id"
    t.integer "event_vendor_id"
    t.integer "cogs_cents"
    t.integer "sell_price_cents"
    t.integer "retail_price_cents"
  end

  create_table "menu_template_groups", :force => true do |t|
    t.integer  "menu_template_id"
    t.integer  "choices_to_select"
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "menu_template_inventory_items", :force => true do |t|
    t.integer  "inventory_item_id"
    t.integer  "menu_template_id"
    t.integer  "menu_template_group_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "menu_templates", :force => true do |t|
    t.string   "name"
    t.string   "pricing_type"
    t.date     "expiration_date"
    t.date     "start_date",                                                    :null => false
    t.integer  "vendor_id"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.string   "product_type",                 :limit => 20
    t.integer  "cogs_cents"
    t.integer  "sell_price_cents"
    t.integer  "retail_price_cents"
    t.boolean  "expires"
    t.boolean  "all_items",                                  :default => false, :null => false
    t.boolean  "is_eligible_for_self_service",               :default => false, :null => false
    t.string   "cuisine"
    t.text     "dietary_restrictions"
    t.text     "external_tags"
    t.text     "description"
    t.integer  "min_quantity",                               :default => 0,     :null => false
    t.boolean  "is_default",                                 :default => false
  end

  create_table "menu_templates_users", :force => true do |t|
    t.integer "menu_template_id"
    t.integer "user_id"
  end

  create_table "option_groups", :force => true do |t|
    t.string  "name"
    t.integer "included"
    t.integer "max"
    t.integer "inventory_item_id"
    t.integer "required"
  end

  create_table "options", :force => true do |t|
    t.string   "name"
    t.integer  "inventory_item_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "payment_histories", :force => true do |t|
    t.integer  "event_id"
    t.string   "transaction_id"
    t.string   "cc_last4"
    t.string   "customer_id"
    t.string   "status"
    t.float    "amount"
    t.string   "transaction_type"
    t.datetime "timestamp"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.boolean  "is_latest"
    t.string   "card_type"
    t.string   "nickname"
    t.string   "exp_date"
  end

  add_index "payment_histories", ["event_id"], :name => "index_payment_histories_on_event_id"

  create_table "pricing_tiers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.decimal  "gross_profit"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.integer  "contact_id"
    t.integer  "rating"
    t.text     "content"
    t.integer  "event_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "rating_type"
    t.string   "additional_event_ratings"
  end

  add_index "reviews", ["contact_id"], :name => "index_reviews_on_contact_id"
  add_index "reviews", ["event_id"], :name => "index_reviews_on_event_id"
  add_index "reviews", ["reviewable_id"], :name => "index_reviews_on_reviewable_id"

  create_table "reviews_rollups", :force => true do |t|
    t.integer  "reference_id"
    t.string   "reference_type"
    t.string   "product_type"
    t.text     "event_level_reviews"
    t.text     "item_level_reviews"
    t.text     "food_presentation_reviews"
    t.text     "order_accuracy_reviews"
    t.text     "delivery_reviews"
    t.text     "ease_of_ordering_reviews"
    t.text     "customer_service_reviews"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "reviews_vendors", :id => false, :force => true do |t|
    t.integer "review_id"
    t.integer "vendor_id"
  end

  create_table "rs_evaluations", :force => true do |t|
    t.string   "reputation_name"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.float    "value",           :default => 0.0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "rs_evaluations", ["reputation_name", "source_id", "source_type", "target_id", "target_type"], :name => "index_rs_evaluations_on_reputation_name_and_source_and_target", :unique => true
  add_index "rs_evaluations", ["reputation_name"], :name => "index_rs_evaluations_on_reputation_name"
  add_index "rs_evaluations", ["source_id", "source_type"], :name => "index_rs_evaluations_on_source_id_and_source_type"
  add_index "rs_evaluations", ["target_id", "target_type"], :name => "index_rs_evaluations_on_target_id_and_target_type"

  create_table "rs_reputation_messages", :force => true do |t|
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "receiver_id"
    t.float    "weight",      :default => 1.0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "rs_reputation_messages", ["receiver_id", "sender_id", "sender_type"], :name => "index_rs_reputation_messages_on_receiver_id_and_sender", :unique => true
  add_index "rs_reputation_messages", ["receiver_id"], :name => "index_rs_reputation_messages_on_receiver_id"
  add_index "rs_reputation_messages", ["sender_id", "sender_type"], :name => "index_rs_reputation_messages_on_sender_id_and_sender_type"

  create_table "rs_reputations", :force => true do |t|
    t.string   "reputation_name"
    t.float    "value",           :default => 0.0
    t.string   "aggregated_by"
    t.integer  "target_id"
    t.string   "target_type"
    t.boolean  "active",          :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "rs_reputations", ["reputation_name", "target_id", "target_type"], :name => "index_rs_reputations_on_reputation_name_and_target", :unique => true
  add_index "rs_reputations", ["reputation_name"], :name => "index_rs_reputations_on_reputation_name"
  add_index "rs_reputations", ["target_id", "target_type"], :name => "index_rs_reputations_on_target_id_and_target_type"

  create_table "select_event_billing_references", :id => false, :force => true do |t|
    t.integer "select_event_id"
    t.integer "billing_reference_id"
  end

  add_index "select_event_billing_references", ["select_event_id", "billing_reference_id"], :name => "select_event_billing_references_select_billing", :unique => true

  create_table "select_event_campaigns", :force => true do |t|
    t.integer  "select_event_id"
    t.string   "state"
    t.string   "email_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "campaign_id"
    t.integer  "created_by_id"
    t.integer  "campaign_web_id"
    t.string   "email_list_id"
    t.datetime "scheduled_at"
    t.datetime "scheduled_at_utc"
  end

  create_table "select_event_schedule_billing_references", :id => false, :force => true do |t|
    t.integer "select_event_schedule_id"
    t.integer "billing_reference_id"
  end

  add_index "select_event_schedule_billing_references", ["select_event_schedule_id", "billing_reference_id"], :name => "select_event_schedule_billing_references_select_billing", :unique => true

  create_table "select_event_schedule_vendors", :force => true do |t|
    t.integer "account_id"
    t.integer "select_event_schedule_id"
    t.integer "vendor_id"
    t.integer "menu_template_id"
  end

  create_table "select_event_schedules", :force => true do |t|
    t.string   "schedule"
    t.integer  "ready_and_bagged",                          :default => 40,     :null => false
    t.time     "delivery_time"
    t.time     "ordering_window_start_time"
    t.time     "ordering_window_end_time"
    t.integer  "created_by_id"
    t.datetime "created_at",                                                    :null => false
    t.integer  "account_id"
    t.integer  "location_id"
    t.string   "product"
    t.integer  "contact_id"
    t.string   "meal_period"
    t.integer  "event_schedule_owner_id"
    t.string   "gratuity_payer",                            :default => "user"
    t.integer  "default_gratuity",                          :default => 10
    t.string   "delivery_fee_payer",                        :default => "user"
    t.string   "tax_payer",                                 :default => "user"
    t.string   "string",                                    :default => "user"
    t.string   "subsidy",                                   :default => "none"
    t.boolean  "is_subsidy_percentage_capped",              :default => false
    t.integer  "subsidy_percentage_cap"
    t.integer  "subsidy_percentage_fixed_amount_cap_cents"
    t.datetime "updated_at",                                                    :null => false
    t.boolean  "hide_gratuity_from_site",                   :default => false
    t.boolean  "hide_delivery_fee_from_site",               :default => false
    t.boolean  "hide_tax_from_site",                        :default => false
    t.integer  "subsidy_fixed_amount_cents"
    t.string   "email_list_id"
    t.time     "introduction_email_time"
    t.time     "final_email_time"
    t.boolean  "user_contribution_required",                :default => false
    t.integer  "user_contribution_cents"
    t.datetime "schedule_start_date"
    t.datetime "schedule_end_date"
    t.datetime "pause_start_date"
    t.datetime "pause_end_date"
    t.integer  "days_to_schedule"
  end

  create_table "select_event_vendors", :force => true do |t|
    t.integer  "select_event_id"
    t.integer  "vendor_id"
    t.integer  "menu_template_id"
    t.datetime "vendor_billing_summary_sent_at"
  end

  create_table "select_events", :force => true do |t|
    t.integer  "ready_and_bagged",                                              :null => false
    t.datetime "delivery_time"
    t.datetime "delivery_time_utc"
    t.datetime "ordering_window_start_time"
    t.datetime "ordering_window_end_time"
    t.datetime "ordering_window_start_time_utc"
    t.datetime "ordering_window_end_time_utc"
    t.integer  "created_by_id"
    t.integer  "deleted_by_id"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.datetime "deleted_at"
    t.string   "gratuity_payer",                            :default => "user"
    t.decimal  "default_gratuity",                          :default => 10.0
    t.string   "delivery_fee_payer",                        :default => "user"
    t.string   "tax_payer",                                 :default => "user"
    t.string   "subsidy",                                   :default => "none"
    t.boolean  "is_subsidy_percentage_capped",              :default => false
    t.decimal  "subsidy_percentage_cap"
    t.integer  "subsidy_percentage_fixed_amount_cap_cents"
    t.integer  "subsidy_fixed_amount_cents"
    t.boolean  "hide_gratuity_from_site",                   :default => false
    t.boolean  "hide_delivery_fee_from_site",               :default => false
    t.boolean  "hide_tax_from_site",                        :default => false
    t.integer  "account_id"
    t.integer  "location_id"
    t.integer  "contact_id"
    t.string   "meal_period"
    t.integer  "event_owner_id"
    t.string   "status"
    t.string   "email_list_id"
    t.datetime "introduction_email_time"
    t.datetime "final_email_time"
    t.integer  "introduction_email_campaign_id"
    t.integer  "final_email_campaign_id"
    t.boolean  "user_contribution_required",                :default => false
    t.integer  "user_contribution_cents"
    t.datetime "introduction_email_time_utc"
    t.datetime "final_email_time_utc"
  end

  create_table "select_order_item_options", :force => true do |t|
    t.integer  "select_order_item_id"
    t.integer  "inventory_item_id"
    t.integer  "quantity"
    t.text     "special_instructions"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "unit_price_cents"
    t.integer  "option_group_id"
  end

  create_table "select_order_items", :force => true do |t|
    t.integer  "inventory_item_id"
    t.integer  "select_order_id"
    t.integer  "quantity"
    t.text     "special_instructions"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "vendor_id"
    t.integer  "unit_price_cents",     :default => 0, :null => false
    t.string   "status"
  end

  create_table "select_order_transactions", :force => true do |t|
    t.integer  "select_event_id"
    t.integer  "select_order_id"
    t.integer  "card_id"
    t.integer  "user_id"
    t.integer  "account_id"
    t.float    "amount"
    t.string   "notes"
    t.datetime "timestamp"
    t.boolean  "is_refund"
    t.string   "customer_id"
    t.string   "transaction_id"
    t.string   "transaction_type"
    t.string   "status"
    t.string   "response"
    t.boolean  "superceded"
    t.string   "cc_last4"
    t.string   "card_type"
    t.string   "expiration_date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "select_orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "select_event_id"
    t.string   "status"
    t.integer  "subtotal_amount_cents"
    t.integer  "gratuity_amount_cents"
    t.integer  "delivery_amount_cents"
    t.integer  "tax_amount_cents"
    t.integer  "total_amount_cents"
    t.boolean  "edit_mode",             :default => false
    t.integer  "subsidy_amount_cents"
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "ssp_persistences", :force => true do |t|
    t.string  "ssp_persistence_type"
    t.string  "name"
    t.text    "parameters"
    t.boolean "locked",               :default => false, :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tokens", :force => true do |t|
    t.integer  "identity_id"
    t.string   "identity_type"
    t.string   "digest"
    t.datetime "accessed_at"
    t.datetime "expires_at"
    t.string   "data"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "tokens", ["identity_id"], :name => "index_tokens_on_identity_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                     :default => "",    :null => false
    t.string   "encrypted_password",                        :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                             :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.string   "first_name",                  :limit => 40
    t.string   "last_name",                   :limit => 40
    t.boolean  "disable",                                   :default => false
    t.string   "created_by"
    t.integer  "default_account_location_id"
    t.integer  "default_billing_id"
    t.integer  "default_contact_id"
    t.integer  "roles_mask"
    t.datetime "deleted_at"
    t.string   "payment_method"
    t.integer  "default_account_id"
    t.string   "phone_number"
    t.string   "position"
    t.datetime "agreed_terms_at"
    t.boolean  "utility_account",                           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vendor_documents", :force => true do |t|
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.integer  "vendor_insurance_id"
    t.integer  "user_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "vendor_insurances", :force => true do |t|
    t.integer  "building_id"
    t.integer  "vendor_id"
    t.integer  "user_id"
    t.date     "insurance_effective_date"
    t.date     "insurance_expiration_date"
    t.string   "waiver_subrogation"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "vendor_preferences", :force => true do |t|
    t.string  "preference_type"
    t.integer "account_id"
    t.integer "location_id"
    t.string  "disposition"
    t.integer "vendor_id"
  end

  create_table "vendor_product_types", :force => true do |t|
    t.integer "vendor_id"
    t.string  "product_type", :limit => 20
    t.string  "status",                     :default => "inactive"
  end

  create_table "vendor_products", :force => true do |t|
    t.string  "product",      :limit => 30
    t.integer "vendor_id"
    t.string  "product_type", :limit => 20
  end

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.string   "legal_name"
    t.text     "description"
    t.string   "website"
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.decimal  "default_tax_rate",                                         :default => 0.0,          :null => false
    t.integer  "address_id"
    t.integer  "vendor_manager_id"
    t.text     "bio"
    t.decimal  "rating",                     :precision => 2, :scale => 1
    t.integer  "review_count"
    t.string   "rating_image_url"
    t.string   "yelp_url"
    t.string   "yelp_id"
    t.string   "vendor_type",                                              :default => "Restaurant"
    t.float    "vendor_minimum",                                           :default => 100.0
    t.integer  "concurrent_orders",                                        :default => 2
    t.integer  "concurrent_orders_time",                                   :default => 30
    t.decimal  "managed_services_lead_time",                               :default => 21.0
    t.float    "fee"
    t.boolean  "is_fixed",                                                 :default => false
    t.float    "cap",                                                      :default => 100.0
  end

  create_table "voucher_groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "cogs_cents"
    t.integer  "quantity"
    t.integer  "event_id"
    t.integer  "order_id"
    t.integer  "line_item_id"
    t.integer  "voucher_template_id"
    t.integer  "purcashed_by_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "document_id"
  end

  create_table "voucher_templates", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "cogs_cents"
    t.string   "line_item_sku"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "vouchers", :force => true do |t|
    t.integer  "voucher_group_id"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "redeemed_at"
    t.integer  "redeemed_by_id"
    t.string   "status",           :default => "unused"
  end

  create_table "zip_codes", :force => true do |t|
    t.string   "zipcode"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_foreign_key "account_preferences", "accounts", :name => "account_preferences_account_id_fk"
  add_foreign_key "account_preferences", "vendors", :name => "account_preferences_vendor_id_fk"

  add_foreign_key "account_pricing_tiers", "accounts", :name => "account_pricing_tiers_account_id_fk"
  add_foreign_key "account_pricing_tiers", "pricing_tiers", :name => "account_pricing_tiers_pricing_tier_id_fk"

  add_foreign_key "accounts", "addresses", :name => "accounts_address_id_fk"
  add_foreign_key "accounts", "users", :name => "accounts_account_exec_id_fk", :column => "account_exec_id"
  add_foreign_key "accounts", "users", :name => "accounts_account_manager_id_fk", :column => "account_manager_id"
  add_foreign_key "accounts", "users", :name => "accounts_sales_rep_id_fk", :column => "sales_rep_id"

  add_foreign_key "accounts_buildings", "accounts", :name => "accounts_buildings_account_id_fk"
  add_foreign_key "accounts_buildings", "buildings", :name => "accounts_buildings_building_id_fk"

  add_foreign_key "billing_references", "accounts", :name => "billing_references_account_id_fk"
  add_foreign_key "billing_references", "events", :name => "billing_references_event_id_fk"

  add_foreign_key "building_documents", "buildings", :name => "building_documents_building_id_fk"
  add_foreign_key "building_documents", "users", :name => "building_documents_user_id_fk"

  add_foreign_key "buildings", "addresses", :name => "buildings_address_id_fk"
  add_foreign_key "buildings", "markets", :name => "buildings_market_id_fk"

  add_foreign_key "capacities", "vendors", :name => "capacities_vendor_id_fk"

  add_foreign_key "catering_orders", "accounts", :name => "catering_orders_account_id_fk"
  add_foreign_key "catering_orders", "contacts", :name => "catering_orders_contact_id_fk"
  add_foreign_key "catering_orders", "events", :name => "catering_orders_event_id_fk"
  add_foreign_key "catering_orders", "locations", :name => "catering_orders_location_id_fk"
  add_foreign_key "catering_orders", "users", :name => "catering_orders_user_id_fk"

  add_foreign_key "comments", "issues", :name => "comments_issue_id_fk"
  add_foreign_key "comments", "users", :name => "comments_user_id_fk"

  add_foreign_key "contacts", "accounts", :name => "contacts_account_id_fk"
  add_foreign_key "contacts", "vendors", :name => "contacts_vendor_id_fk"

  add_foreign_key "documents", "events", :name => "documents_event_id_fk"
  add_foreign_key "documents", "users", :name => "documents_creator_id_fk", :column => "creator_id"

  add_foreign_key "event_schedules", "accounts", :name => "event_schedules_account_id_fk"
  add_foreign_key "event_schedules", "contacts", :name => "event_schedules_contact_id_fk"
  add_foreign_key "event_schedules", "locations", :name => "event_schedules_location_id_fk"
  add_foreign_key "event_schedules", "menu_templates", :name => "event_schedules_menu_template_id_fk"
  add_foreign_key "event_schedules", "users", :name => "event_schedules_created_by_id_fk", :column => "created_by_id"
  add_foreign_key "event_schedules", "vendors", :name => "event_schedules_vendor_id_fk"

  add_foreign_key "event_transactions", "events", :name => "event_transactions_event_id_fk"

  add_foreign_key "event_vendors", "event_transaction_methods", :name => "event_vendors_event_transaction_method_id_fk"
  add_foreign_key "event_vendors", "events", :name => "event_vendors_event_id_fk"
  add_foreign_key "event_vendors", "menu_templates", :name => "event_vendors_menu_template_id_fk"
  add_foreign_key "event_vendors", "vendors", :name => "event_vendors_vendor_id_fk"

  add_foreign_key "events", "accounts", :name => "events_account_id_fk"
  add_foreign_key "events", "contacts", :name => "events_contact_id_fk"
  add_foreign_key "events", "event_managed_services_rollups", :name => "events_event_managed_services_rollup_id_fk"
  add_foreign_key "events", "event_schedules", :name => "events_event_schedule_id_fk"
  add_foreign_key "events", "event_transaction_methods", :name => "events_event_transaction_method_id_fk"
  add_foreign_key "events", "locations", :name => "events_location_id_fk"
  add_foreign_key "events", "users", :name => "events_created_by_id_fk", :column => "created_by_id"

  add_foreign_key "inventory_item_product_types", "inventory_items", :name => "inventory_item_product_types_inventory_item_id_fk"

  add_foreign_key "inventory_items", "vendors", :name => "inventory_items_vendor_id_fk"

  add_foreign_key "inventory_items_option_groups", "inventory_items", :name => "inventory_items_option_groups_inventory_item_id_fk"
  add_foreign_key "inventory_items_option_groups", "option_groups", :name => "inventory_items_option_groups_option_group_id_fk"

  add_foreign_key "issues", "users", :name => "issues_assignee_id_fk", :column => "assignee_id"
  add_foreign_key "issues", "users", :name => "issues_assigner_id_fk", :column => "assigner_id"

  add_foreign_key "line_items", "documents", :name => "line_items_document_id_fk"
  add_foreign_key "line_items", "events", :name => "line_items_event_id_fk"
  add_foreign_key "line_items", "inventory_items", :name => "line_items_inventory_item_id_fk"
  add_foreign_key "line_items", "line_items", :name => "line_items_add_on_parent_id_fk", :column => "add_on_parent_id"
  add_foreign_key "line_items", "line_items", :name => "line_items_opposing_line_item_id_fk", :column => "opposing_line_item_id"
  add_foreign_key "line_items", "menu_templates", :name => "line_items_menu_template_id_fk"

  add_foreign_key "locations", "accounts", :name => "locations_account_id_fk"
  add_foreign_key "locations", "buildings", :name => "locations_building_id_fk"
  add_foreign_key "locations", "contacts", :name => "locations_contact_id_fk"

  add_foreign_key "menu_level_discounts", "event_vendors", :name => "menu_level_discounts_event_vendor_id_fk"
  add_foreign_key "menu_level_discounts", "menu_templates", :name => "menu_level_discounts_menu_template_id_fk"

  add_foreign_key "menu_template_groups", "menu_templates", :name => "menu_template_groups_menu_template_id_fk"

  add_foreign_key "menu_template_inventory_items", "inventory_items", :name => "menu_template_inventory_items_inventory_item_id_fk"
  add_foreign_key "menu_template_inventory_items", "menu_template_groups", :name => "menu_template_inventory_items_menu_template_group_id_fk"
  add_foreign_key "menu_template_inventory_items", "menu_templates", :name => "menu_template_inventory_items_menu_template_id_fk"

  add_foreign_key "menu_templates", "vendors", :name => "menu_templates_vendor_id_fk"

  add_foreign_key "option_groups", "inventory_items", :name => "option_groups_inventory_item_id_fk"

  add_foreign_key "payment_histories", "events", :name => "payment_histories_event_id_fk"
  add_foreign_key "payment_histories", "users", :name => "payment_histories_user_id_fk"

  add_foreign_key "rs_reputation_messages", "rs_reputations", :name => "rs_reputation_messages_receiver_id_fk", :column => "receiver_id"

  add_foreign_key "select_events", "accounts", :name => "select_events_account_id_fk"
  add_foreign_key "select_events", "contacts", :name => "select_events_contact_id_fk"
  add_foreign_key "select_events", "locations", :name => "select_events_location_id_fk"
  add_foreign_key "select_events", "users", :name => "select_events_created_by_id_fk", :column => "created_by_id"
  add_foreign_key "select_events", "users", :name => "select_events_deleted_by_id_fk", :column => "deleted_by_id"
  add_foreign_key "select_events", "users", :name => "select_events_event_owner_id_fk", :column => "event_owner_id"

  add_foreign_key "taggings", "tags", :name => "taggings_tag_id_fk"

  add_foreign_key "vendor_documents", "users", :name => "vendor_documents_user_id_fk"
  add_foreign_key "vendor_documents", "vendor_insurances", :name => "vendor_documents_vendor_insurance_id_fk"

  add_foreign_key "vendor_insurances", "buildings", :name => "vendor_insurances_building_id_fk"
  add_foreign_key "vendor_insurances", "users", :name => "vendor_insurances_user_id_fk"
  add_foreign_key "vendor_insurances", "vendors", :name => "vendor_insurances_vendor_id_fk"

  add_foreign_key "vendor_preferences", "accounts", :name => "vendor_preferences_account_id_fk"
  add_foreign_key "vendor_preferences", "locations", :name => "vendor_preferences_location_id_fk"
  add_foreign_key "vendor_preferences", "vendors", :name => "vendor_preferences_vendor_id_fk"

  add_foreign_key "vendor_product_types", "vendors", :name => "vendor_product_types_vendor_id_fk"

  add_foreign_key "vendor_products", "vendors", :name => "vendor_products_vendor_id_fk"

  add_foreign_key "vendors", "addresses", :name => "vendors_address_id_fk"
  add_foreign_key "vendors", "users", :name => "vendors_vendor_manager_id_fk", :column => "vendor_manager_id"

end
