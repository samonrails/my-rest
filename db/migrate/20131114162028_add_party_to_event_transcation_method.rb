class AddPartyToEventTranscationMethod < ActiveRecord::Migration
  def change
    add_column :event_transaction_methods, :party_type, :string
    add_column :event_transaction_methods, :party_id, :integer
  end
end
