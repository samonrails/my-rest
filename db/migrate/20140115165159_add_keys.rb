class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "catering_orders", "accounts", :name => "catering_orders_account_id_fk"
    add_foreign_key "catering_orders", "contacts", :name => "catering_orders_contact_id_fk"
    add_foreign_key "catering_orders", "events", :name => "catering_orders_event_id_fk"
    add_foreign_key "catering_orders", "locations", :name => "catering_orders_location_id_fk"
    #add_foreign_key "catering_orders", "menu_templates", :name => "catering_orders_menu_template_id_fk"
    add_foreign_key "catering_orders", "users", :name => "catering_orders_user_id_fk"
    add_foreign_key "event_transactions", "events", :name => "event_transactions_event_id_fk"
    add_foreign_key "payment_histories", "events", :name => "payment_histories_event_id_fk"
    add_foreign_key "payment_histories", "users", :name => "payment_histories_user_id_fk"
    add_foreign_key "rs_reputation_messages", "rs_reputations", :name => "rs_reputation_messages_receiver_id_fk", :column => "receiver_id"
    add_foreign_key "select_events", "users", :name => "select_events_created_by_id_fk", :column => "created_by_id"
    add_foreign_key "select_events", "users", :name => "select_events_deleted_by_id_fk", :column => "deleted_by_id"
  end
end
