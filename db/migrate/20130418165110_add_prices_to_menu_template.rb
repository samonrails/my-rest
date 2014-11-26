class AddPricesToMenuTemplate < ActiveRecord::Migration
  def up
    add_column :menu_templates, :buy_price, :float
    add_column :menu_templates, :sell_price, :float
  end

  def down
    remove_column :menu_templates, :buy_price
    remove_column :menu_templates, :sell_price
  end
end
