class AddOrderType < ActiveRecord::Migration
  def up
    add_column :catering_orders, :order_type, :string, :default => "catering"

    Catering::Order.all.map { |o| o.order_type = "catering"; o.save}
  end

  def down
    remove_column :catering_orders, :order_type
  end
end
