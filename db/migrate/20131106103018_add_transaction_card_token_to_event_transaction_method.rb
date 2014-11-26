class AddTransactionCardTokenToEventTransactionMethod < ActiveRecord::Migration
  def change
    add_column :event_transaction_methods, :transaction_card_token, :string
  end
end
