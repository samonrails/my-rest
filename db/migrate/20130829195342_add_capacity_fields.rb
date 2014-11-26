class AddCapacityFields < ActiveRecord::Migration
  def up
    add_column :vendors, :min_capacity_usd, :float, :null => false, :default => 0

    # Removed for cherry-picked SnapPea Relase v1.7.0
    # add_column :menu_templates, :min_quantity, :integer, :null => false, :default => 0
    #add_column :inventory_items, :min_quantity, :integer, :null => false, :default => 0

    # MenuTemplate.all.map(&:update_average_per_person_price)
  end

  def down
    remove_column :vendors, :min_capacity_usd
    
    # Removed for cherry-picked SnapPea Relase v1.7.0
    # remove_column :menu_templates, :min_quantity
    # remove_column :inventory_items, :min_quantity
    remove_column :menu_templates, :average_per_person_price
  end

end
