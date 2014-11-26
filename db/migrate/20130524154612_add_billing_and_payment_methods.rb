class AddBillingAndPaymentMethods < ActiveRecord::Migration
  def up
    create_table :event_transaction_methods do |t|
      t.string :transaction_method, :limit => 255
      t.string :info1, :limit => 255
      t.string :info2, :limit => 255
    end
  
    add_column :event_vendors, :event_transaction_method_id, :integer
    add_column :events, :event_transaction_method_id, :integer
  end

  def down
    drop_table :event_transaction_methods

    remove_column :event_vendors, :event_transaction_method_id, :integer
    remove_column :events, :event_transaction_method_id, :integer
  end
end
