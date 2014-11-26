# This migration comes from lunchbox (originally 20131008213517)
class UpdateOrderFields < ActiveRecord::Migration
  def up

    remove_column :lunchbox_orders, :lunchbox_billing_id
    remove_column :lunchbox_orders, :lunchbox_shipping_id
    remove_column :lunchbox_orders, :lunchbox_contact_id

    add_column :lunchbox_orders, :billing_reference_id, :integer
    add_column :lunchbox_orders, :order_quantity, :integer
    add_column :lunchbox_orders, :location_id, :integer
    add_column :lunchbox_orders, :contact_id, :integer
    add_column :lunchbox_orders, :total, :integer
    add_column :lunchbox_orders, :event_id, :integer
  end

  def down
    add_column :lunchbox_orders, :lunchbox_billing_id, :integer
    add_column :lunchbox_orders, :lunchbox_shipping_id, :integer
    add_column :lunchbox_orders, :lunchbox_contact_id, :integer

    remove_column :lunchbox_orders, :billing_reference_id
    remove_column :lunchbox_orders, :order_quantity
    remove_column :lunchbox_orders, :location_id
    remove_column :lunchbox_orders, :contact_id
    remove_column :lunchbox_orders, :total
    remove_column :lunchbox_orders, :event_id
  end
end
