class RenameSelectOrderInventoryItemToSelectOrderItem < ActiveRecord::Migration
  def up
    rename_table :inventory_item_select_orders, :select_order_items
    rename_table :inventory_item_option_inventory_item_select_orders, :select_order_item_options
  end

  def down
  end
end
