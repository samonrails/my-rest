class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, :limit => 40
  end
end
