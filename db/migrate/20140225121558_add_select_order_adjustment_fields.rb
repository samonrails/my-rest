class AddSelectOrderAdjustmentFields < ActiveRecord::Migration
  def up
    # select_orders
    add_column :select_orders, :edit_mode, :boolean, default: false
    # inventory_item_select_orders
    add_column :inventory_item_select_orders, :status, :string
  end

  def down
    # inventory_item_select_orders
    remove_column :inventory_item_select_orders, :status
    # select_orders
    remove_column :select_orders, :edit_mode
  end
end
