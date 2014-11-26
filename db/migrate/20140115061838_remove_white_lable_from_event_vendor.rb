class RemoveWhiteLableFromEventVendor < ActiveRecord::Migration
  def up
    remove_column :event_vendors, :white_label_fooda
  end

  def down
    add_column :menu_templates, :white_label_fooda, :boolean, :default => false, :null => false
  end
end
