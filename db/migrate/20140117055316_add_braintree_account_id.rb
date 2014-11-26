class AddBraintreeAccountId < ActiveRecord::Migration
  def change
    add_column :braintree_accounts, :braintree_id, :string
  end
end
