class DropProductDatabaseArtifacts < ActiveRecord::Migration
  def up
    drop_table :products
    drop_table :product_types
    drop_table :vendor_product_types

    remove_column :menu_templates, :product_type_id
    remove_column :vendor_products, :product_id
    add_column :vendor_products, :product, :string, :limit => 20
  end

  def down
  end
end
