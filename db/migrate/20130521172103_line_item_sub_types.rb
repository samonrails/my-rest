class LineItemSubTypes < ActiveRecord::Migration
  def up
    add_column :line_items, :line_item_sub_type, :string

    create_table :line_item_types do |t|
      t.string    :line_item_type
      t.string    :line_item_sub_type
      t.string    :sku
      t.timestamps
    end

  end

  def down
    remove_column :line_items, :line_item_sub_type

    drop_table :line_item_types
  end
end
