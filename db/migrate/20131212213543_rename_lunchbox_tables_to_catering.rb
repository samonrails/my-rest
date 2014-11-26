class RenameLunchboxTablesToCatering < ActiveRecord::Migration
  def change
    rename_table :lunchbox_billings, :catering_billings
    rename_table :lunchbox_contacts, :catering_contacts
    rename_table :lunchbox_orders, :catering_orders
    rename_table :lunchbox_sessions, :catering_sessions
    rename_table :lunchbox_shippings, :catering_shippings
  end
end
