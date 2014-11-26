class AddMinQuantitiyToMenuTemplates < ActiveRecord::Migration
  def change
    add_column :menu_templates, :min_quantity, :integer
  end
end
