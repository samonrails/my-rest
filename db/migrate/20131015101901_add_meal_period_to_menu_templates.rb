class AddMealPeriodToMenuTemplates < ActiveRecord::Migration
  def change
    add_column :menu_templates, :meal_period, :string
    add_column :menu_templates, :description, :text
  end
end
