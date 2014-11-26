class AddRetailPriceToMenuTemplate < ActiveRecord::Migration
  def up
    add_column :menu_templates, :retail_price, :decimal
    add_column :menu_level_discounts, :retail_price, :decimal
    add_column :event_vendors, :default_menu_retail_price, :decimal
  end

  def down
    remove_column :menu_templates, :retail_price
    remove_column :menu_level_discounts, :retail_price
    remove_column :event_vendors, :default_menu_retail_price
  end
end
