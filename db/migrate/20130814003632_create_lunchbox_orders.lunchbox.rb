# This migration comes from lunchbox (originally 20130808165537)
class CreateLunchboxOrders < ActiveRecord::Migration
  def change
    create_table :lunchbox_orders do |t|
      t.string :shipping_address1
      t.string :shipping_address2
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_zip_code

      t.timestamps
    end
  end
end
