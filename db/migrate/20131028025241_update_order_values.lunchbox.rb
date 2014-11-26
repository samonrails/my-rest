# This migration comes from lunchbox (originally 20131028011345)
class UpdateOrderValues < ActiveRecord::Migration
  def up
    add_column :lunchbox_orders, :order_builder_dump, :text

    remove_column :lunchbox_orders, :menu_template_id
    remove_column :lunchbox_orders, :order_quantity
  end

  def down
    remove_column :lunchbox_orders, :order_builder_dump

    add_column :lunchbox_orders, :menu_template_id, :integer
    add_column :lunchbox_orders, :order_quantity, :integer
  end
end
