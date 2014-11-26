class CreateSelectOrderTransactions < ActiveRecord::Migration
  def change
    create_table :select_order_transactions do |t|
      # SnapPea specific data
      t.belongs_to :select_event
      t.belongs_to :select_order
      t.belongs_to :card
      t.belongs_to :user
      t.belongs_to :account
      t.float :amount
      t.string :notes
      t.datetime :timestamp
      t.boolean :is_refund

      # Braintree specific data
      t.string :customer_id
      t.string :transaction_id
      t.string :transaction_type
      t.string :status
      t.string :response
      t.boolean :superceded

      # SnapPea display metadata (filled after braintree transactions)
      t.string :cc_last4
      t.string :card_type
      t.string :expiration_date

      t.timestamps
    end
  end
end
