class AddAccountStatusContactToSelectEvents < ActiveRecord::Migration
  def change
    add_column :select_events, :account_id, :integer
    add_column :select_events, :location_id, :integer
    add_column :select_events, :contact_id, :integer
    add_column :select_events, :meal_period, :string
    add_column :select_events, :event_owner_id, :integer
    add_column :select_events, :status, :string
  end
end
