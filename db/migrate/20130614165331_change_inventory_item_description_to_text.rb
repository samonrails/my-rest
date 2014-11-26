class ChangeInventoryItemDescriptionToText < ActiveRecord::Migration
  def change
    change_column :inventory_items, :description, :text
  end
end
