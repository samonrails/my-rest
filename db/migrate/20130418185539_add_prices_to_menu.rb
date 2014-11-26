class AddPricesToMenu < ActiveRecord::Migration
  def up
    add_column :menus, :buy_price, :float
  end
  def down
    remove_column :menus, :buy_price, :float
  end
end
