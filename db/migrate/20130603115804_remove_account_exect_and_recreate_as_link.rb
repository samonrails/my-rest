class RemoveAccountExectAndRecreateAsLink < ActiveRecord::Migration
  def change
    remove_column :accounts, :account_exec
    add_column :accounts, :account_exec_id, :int
    add_column :accounts, :sales_rep_id, :int
    add_column :accounts, :account_manager_id, :int

    add_column :vendors, :vendor_manager_id, :string

  end

  def down
    add_column :accounts, :account_exec, :string
    remove_column :accounts, :account_exec_id
    remove_column :accounts, :sales_rep_id
    remove_column :accounts, :account_manager_id

    remove_column :vendors, :vendor_manager_id
  end
end
