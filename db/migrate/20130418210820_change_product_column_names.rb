class ChangeProductColumnNames < ActiveRecord::Migration
  def up
    add_column :menu_templates, :product, :string, :limit => 20
    add_column :menu_templates, :product_type, :string, :limit => 20
  end

  def down
  end
end
