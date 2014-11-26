class CreateBraintreeAccounts < ActiveRecord::Migration
  def change
    create_table :braintree_accounts do |t|
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end
  end
end
