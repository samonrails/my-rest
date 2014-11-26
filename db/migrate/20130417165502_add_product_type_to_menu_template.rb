class AddProductTypeToMenuTemplate < ActiveRecord::Migration
  def up
    add_column :menu_templates, :product_type_id, :integer
    remove_column :menu_templates, :product_id
  end

  def down
    remove_column :menu_templates, :product_type_id
    add_column :menu_templates, :product_id, :integer
  end
end
