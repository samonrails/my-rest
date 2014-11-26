class RenameInventoryItemSelectOrderIdColumnToSelectOrderItemId < ActiveRecord::Migration
  def up
  	rename_column :select_order_item_options, :inventory_item_select_order_id, :select_order_item_id
  end

  def down
  end
end
