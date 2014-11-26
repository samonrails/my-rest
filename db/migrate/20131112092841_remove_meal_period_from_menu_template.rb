class RemoveMealPeriodFromMenuTemplate < ActiveRecord::Migration
  def up
    remove_column :menu_templates, :meal_period
  end

  def down
    add_column :menu_templates, :meal_period, :string
  end
end
