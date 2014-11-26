class AddSellPriceToInventoryItem < ActiveRecord::Migration
  def up
    add_column :inventory_items, :perks_price, :decimal
    add_column :inventory_items, :product_types, :string
  end
  def down
    remove_column :inventory_items, :perks_price
    remove_column :inventory_items, :product_types, :string
  end
end
