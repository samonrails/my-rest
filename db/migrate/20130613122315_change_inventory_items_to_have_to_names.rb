class ChangeInventoryItemsToHaveToNames < ActiveRecord::Migration
  def change
    rename_column :inventory_items, :name, :name_vendor
    add_column :inventory_items, :name_public, :string
  end
end
