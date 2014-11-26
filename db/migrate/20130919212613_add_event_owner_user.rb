class AddEventOwnerUser < ActiveRecord::Migration
  def change
    add_column :events, :event_owner_id, :integer
  end
end
