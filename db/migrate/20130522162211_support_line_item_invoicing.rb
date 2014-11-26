class SupportLineItemInvoicing < ActiveRecord::Migration
  def change
    add_column :line_items, :document_id, :integer
    add_column :documents, :name, :string
  end
end
