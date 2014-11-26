class AddDefaultValuesToMinQuantityValue < ActiveRecord::Migration
  def up
    change_column :menu_templates, :min_quantity, :integer, :null => false, :default => 0
    change_column :inventory_items, :min_quantity, :integer, :null => false, :default => 0
  end

  def down
    change_column :menu_templates, :min_quantity, :integer, :null => true, :default => nil
    change_column :inventory_items, :min_quantity, :integer, :null => true, :default => nil
  end
end
