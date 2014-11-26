class DefaultForPackagingDetails < ActiveRecord::Migration
  def change
    change_column :inventory_items, :packaging_details, :string, :default => "Family Style"
    InventoryItem.update_all({ :packaging_details => "Family Style" }, { :packaging_details => "Buffet Style" })
  end
end
