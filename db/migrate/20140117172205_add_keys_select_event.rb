class AddKeysSelectEvent < ActiveRecord::Migration
  def change
    #add_foreign_key "catering_orders", "menu_templates", :name => "catering_orders_menu_template_id_fk"
    add_foreign_key "select_events", "accounts", :name => "select_events_account_id_fk"
    add_foreign_key "select_events", "contacts", :name => "select_events_contact_id_fk"
    add_foreign_key "select_events", "users", :name => "select_events_event_owner_id_fk", :column => "event_owner_id"
    add_foreign_key "select_events", "locations", :name => "select_events_location_id_fk"
  end
end
