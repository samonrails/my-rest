class ChangeDocumentCreatedByNaming < ActiveRecord::Migration
  def up
    remove_column :documents, :created_by
    add_column :documents, :creator_id, :integer
  end

  def down
    remove_column :documents, :creator_id
    add_column :documents, :created_by, :string
  end
end
