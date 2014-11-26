class AddLineItemOtherSide < ActiveRecord::Migration
  def change
    add_column :line_items, :opposing_line_item_id, :integer
  end
end
