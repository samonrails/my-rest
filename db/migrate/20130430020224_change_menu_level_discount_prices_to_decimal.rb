class ChangeMenuLevelDiscountPricesToDecimal < ActiveRecord::Migration
  def up
    change_column :menu_level_discounts, :buy_price, :decimal
    change_column :menu_level_discounts, :sell_price, :decimal
  end

  def down
    change_column :menu_level_discounts, :buy_price, :float
    change_column :menu_level_discounts, :sell_price, :float
  end
end
