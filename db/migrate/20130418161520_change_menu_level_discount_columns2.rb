class ChangeMenuLevelDiscountColumns2 < ActiveRecord::Migration
  def up
    remove_column :menu_level_discounts, :dollar_discount
    add_column :menu_level_discounts, :buy_price, :float
    add_column :menu_level_discounts, :sell_price, :float
  end

  def down
    add_column :menu_level_discounts, :dollar_discount, :float
    remove_column :menu_level_discounts, :buy_price
    remove_column :menu_level_discounts, :sell_price
  end
end
