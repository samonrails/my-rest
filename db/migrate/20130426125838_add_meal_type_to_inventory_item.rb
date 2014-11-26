class AddMealTypeToInventoryItem < ActiveRecord::Migration
  def change
    add_column :inventory_items, :meal_type, :string, :limit => 20
  end
end
