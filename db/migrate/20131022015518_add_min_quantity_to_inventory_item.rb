class AddMinQuantityToInventoryItem < ActiveRecord::Migration
  def change
    add_column :inventory_items, :min_quantity, :integer
  end
end
