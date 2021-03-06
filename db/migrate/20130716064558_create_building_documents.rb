class CreateBuildingDocuments < ActiveRecord::Migration
  def change
    create_table :building_documents do |t|
      t.string :document_file_name
      t.string :document_content_type
      t.integer :document_file_size
      t.references :building
      t.integer :user_id

      t.timestamps
    end
  end
end
