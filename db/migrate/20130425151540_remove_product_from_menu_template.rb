class RemoveProductFromMenuTemplate < ActiveRecord::Migration
  def up
    remove_column :menu_templates, :product
  end

  def down
    add_column :menu_templates, :product, :string, :limit => 20
  end
end
