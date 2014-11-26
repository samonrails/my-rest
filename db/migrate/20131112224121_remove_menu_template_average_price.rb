class RemoveMenuTemplateAveragePrice < ActiveRecord::Migration
  def up
    remove_column :menu_templates, :average_per_person_price
  end

  def down
    add_column :menu_templates, :average_per_person_price, :decimal
  end
end
