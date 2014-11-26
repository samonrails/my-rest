class AddEventPaymentUser < ActiveRecord::Migration
  def change
    add_column :event_transaction_methods, :user_id, :integer
  end
end
