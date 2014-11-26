class AddOptionGroupIdForSelectOrderItemOptions < ActiveRecord::Migration
  def up
    # inventory_item_option_inventory_item_select_orders
    add_column :inventory_item_option_inventory_item_select_orders, :option_group_id, :integer
  end

  def down
    # inventory_item_option_inventory_item_select_orders
    remove_column :inventory_item_option_inventory_item_select_orders, :option_group_id
  end
end
