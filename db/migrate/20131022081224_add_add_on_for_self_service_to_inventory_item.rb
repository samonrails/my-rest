class AddAddOnForSelfServiceToInventoryItem < ActiveRecord::Migration
  def change
    rename_column :inventory_items, :add_on, :inventory_item_option
    add_column :inventory_items, :eligible_for_add_ons, :boolean
  end
end
