class RenameUsernameToEmail < ActiveRecord::Migration
  def change
    rename_column :users, :username, :secondary_email
  end
end
