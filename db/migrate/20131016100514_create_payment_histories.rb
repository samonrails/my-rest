class CreatePaymentHistories < ActiveRecord::Migration
  def change
    create_table :payment_histories do |t|
      t.references :event
      t.string :transaction_id
      t.string :cc_last4
      t.string :customer_id
      t.string :description
      t.string :status
      t.float :amount
      t.string :transaction_type
      t.datetime :timestamp

      t.timestamps
    end
    add_index :payment_histories, :event_id
  end
end
