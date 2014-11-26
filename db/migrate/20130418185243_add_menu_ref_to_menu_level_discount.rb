class AddMenuRefToMenuLevelDiscount < ActiveRecord::Migration
  def up
    add_column :menu_level_discounts, :menu_id, :integer
  end

  def down
    remove_column :menu_level_discounts, :menu_id, :integer
  end
end
