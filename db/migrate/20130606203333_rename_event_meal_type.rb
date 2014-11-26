class RenameEventMealType < ActiveRecord::Migration
  def change
    rename_column :events, :meal_type, :meal_period
  end

end
