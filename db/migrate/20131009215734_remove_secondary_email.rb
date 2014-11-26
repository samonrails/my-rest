class RemoveSecondaryEmail < ActiveRecord::Migration
  def up
    remove_column :users, :secondary_email
  end

  def down
    add_column :users, :secondary_email, :string  
  end
end
