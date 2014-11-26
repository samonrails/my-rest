class AddFirstNameLastNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string, :limit => 40
    add_column :users, :last_name, :string, :limit => 40
  end
end
