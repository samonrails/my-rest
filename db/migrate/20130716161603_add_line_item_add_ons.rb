class AddLineItemAddOns < ActiveRecord::Migration
  def change
    add_column :line_items, :add_on_parent_id, :integer, :null => true
    add_column :option_groups, :inventory_item_id, :integer
  end
end
