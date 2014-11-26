class CreateEventTransactions < ActiveRecord::Migration
  def change
    create_table :event_transactions do |t|
      t.references :event
      t.string :transaction_id
      t.string :status
      t.float :amount
      t.string :transaction_type

      t.timestamps
    end
    add_index :event_transactions, :event_id
  end
end
