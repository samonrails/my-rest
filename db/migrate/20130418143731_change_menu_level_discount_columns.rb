class ChangeMenuLevelDiscountColumns < ActiveRecord::Migration
  def up
    remove_column :menu_level_discounts, :max
    rename_column :menu_level_discounts, :min, :min_participation
    rename_column :menu_level_discounts, :dollars, :dollar_discount
  end

  def down
    add_column :menu_level_discounts, :max
    rename_column :menu_level_discounts, :min_participation, :min
    rename_column :menu_level_discounts, :dollar_discount, :dollars
  end
end
