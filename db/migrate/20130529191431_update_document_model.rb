class UpdateDocumentModel < ActiveRecord::Migration
  def change
    rename_column :documents, :amount, :total
    add_column :documents, :file_extension, :string
  end
end
