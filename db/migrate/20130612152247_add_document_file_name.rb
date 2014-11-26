class AddDocumentFileName < ActiveRecord::Migration
  def change
    rename_column :documents, :file_extension, :full_file_name
  end
end

