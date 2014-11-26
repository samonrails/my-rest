class AssociateProductTypesToInventoryItems < ActiveRecord::Migration
  def up
    remove_column :inventory_items, :product_types

    create_table :inventory_item_product_types do |t|
      t.belongs_to :inventory_item
      t.string :product_type, :limit => 20
    end

  end

  def down
    add_column :inventory_items, :product_types, :string

    drop_table :inventory_item_product_types
  end
end
