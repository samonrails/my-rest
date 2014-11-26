class AddWhiteLabelFoodaToEventVendors < ActiveRecord::Migration
  def up
    add_column :event_vendors, :white_label_fooda, :boolean, :null => false, :default => false
  end
  def down
    remove_column :event_vendors, :white_label_fooda
  end
end
