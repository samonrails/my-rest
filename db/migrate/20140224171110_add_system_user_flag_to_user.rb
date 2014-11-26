class AddSystemUserFlagToUser < ActiveRecord::Migration
  def change
    add_column :users, :utility_account, :boolean, default: :false
  end
end
