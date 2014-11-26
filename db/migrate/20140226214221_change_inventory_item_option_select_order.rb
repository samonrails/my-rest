class ChangeInventoryItemOptionSelectOrder < ActiveRecord::Migration
  def up
     rename_column :inventory_item_option_inventory_item_select_orders, :inventory_item_option_id, :inventory_item_id
  end

  def down
  end
end
