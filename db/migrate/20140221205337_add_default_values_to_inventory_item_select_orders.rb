class AddDefaultValuesToInventoryItemSelectOrders < ActiveRecord::Migration
  def up
    change_column :inventory_item_select_orders, :unit_price_cents, :integer, :null => false, :default => 0
  end

  def down
    change_column :inventory_item_select_orders, :unit_price_cents, :integer, :null => true, :default => nil
  end
end
