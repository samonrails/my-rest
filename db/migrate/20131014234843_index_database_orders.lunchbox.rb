# This migration comes from lunchbox (originally 20131014234523)
class IndexDatabaseOrders < ActiveRecord::Migration
  def change
    add_column :lunchbox_orders, :account_id, :integer
    add_index :lunchbox_orders, :account_id
    add_index :lunchbox_orders, :user_id
  end
end
