class AddAccountExecToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :account_exec, :string
  end
end
