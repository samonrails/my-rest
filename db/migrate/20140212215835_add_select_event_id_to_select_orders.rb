class AddSelectEventIdToSelectOrders < ActiveRecord::Migration
  def change
  	add_column :select_orders, :select_event_id, :integer 
  end
end
