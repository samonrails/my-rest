class LineItemSubItems < ActiveRecord::Migration
  def up
    add_column :line_items, :after_subtotal, :boolean
    add_column :line_items, :percentage_of_subtotal, :boolean
  end

  def down
    remove_column :line_items, :after_subtotal
    remove_column :line_items, :percentage_of_subtotal
  end
end
