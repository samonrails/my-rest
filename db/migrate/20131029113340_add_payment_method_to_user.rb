class AddPaymentMethodToUser < ActiveRecord::Migration
  def change
    add_column :users, :payment_method, :string
    add_column :users, :default_account_id, :integer
  end
end
