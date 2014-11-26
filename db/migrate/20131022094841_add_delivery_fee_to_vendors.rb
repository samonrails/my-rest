class AddDeliveryFeeToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :fee, :float
    add_column :vendors, :is_fixed, :boolean, default: false
    add_column :vendors, :cap, :float, default: 100
  end
end
