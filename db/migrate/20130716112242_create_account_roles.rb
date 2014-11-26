class CreateAccountRoles < ActiveRecord::Migration
  def change
    create_table :account_roles do |t|
      t.references :user
      t.references :account
      t.string :role, default: 'member'

      t.timestamps
    end
    add_index :account_roles, :user_id
    add_index :account_roles, :account_id
  end
end
