# This migration comes from lunchbox (originally 20130820144843)
class RemoveOrdersTable < ActiveRecord::Migration
  def up
    drop_table :lunchbox_orders
  end
end
