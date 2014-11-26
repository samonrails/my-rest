class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :description
      t.references :issue
      t.references :user

      t.timestamps
    end
    add_index :comments, :issue_id
    add_index :comments, :user_id
  end
end
