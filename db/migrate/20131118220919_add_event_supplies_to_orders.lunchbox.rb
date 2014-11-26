# This migration comes from lunchbox (originally 20131114064846)
class AddEventSuppliesToOrders < ActiveRecord::Migration
  def change
    add_column :lunchbox_orders, :event_supplies, :boolean, default: true
  end
end
