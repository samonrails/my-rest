class CreateDocumentsTable < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :document_type
      t.string :recipient
      t.string :amount
      
      # current_user.username
      t.string :created_by 

      t.belongs_to :event
      # creation_date here
      t.timestamps
    end
  end
end
