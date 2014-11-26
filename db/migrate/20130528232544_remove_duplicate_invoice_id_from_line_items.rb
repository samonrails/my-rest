class RemoveDuplicateInvoiceIdFromLineItems < ActiveRecord::Migration
  def up
    remove_column :line_items, :invoice_id
  end

  def down
    add_column :line_items, :invoice_id, :string
  end
end
