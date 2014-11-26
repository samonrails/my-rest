class AddFeedsQtyToInventoryItems < ActiveRecord::Migration
  def change
    add_column :inventory_items, :min_feeds, :integer, default: 1
    add_column :inventory_items, :max_feeds, :integer
    add_column :inventory_items, :packaging_details, :string, default: "buffet_style"
  end
end
