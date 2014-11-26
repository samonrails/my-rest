class UpdateLineItemsForInvoicePostSubTotal < ActiveRecord::Migration
  def change
    add_column :line_items, :parent_id, :integer
  end
end
