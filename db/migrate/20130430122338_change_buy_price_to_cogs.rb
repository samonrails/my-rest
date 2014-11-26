class ChangeBuyPriceToCogs < ActiveRecord::Migration
  def up
    add_column :inventory_items, :cogs, :decimal
    remove_column :inventory_items, :buy_price

    add_column :menu_level_discounts, :cogs, :decimal
    remove_column :menu_level_discounts, :buy_price

    add_column :menu_templates, :cogs, :decimal
    remove_column :menu_templates, :buy_price
    change_column :menu_templates, :sell_price, :decimal

    add_column :menus, :cogs, :decimal
    remove_column :menus, :buy_price
    change_column :menus, :sell_price, :decimal
  end

  def down
  end
end
