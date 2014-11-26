class ChangeVendorCapacityColumns < ActiveRecord::Migration
  def change
    remove_column :vendors, :min_capacity
    remove_column :vendors, :max_capacity
    remove_column :vendors, :lead_time_for_min_74_people
    remove_column :vendors, :lead_time_for_75_150_people
    remove_column :vendors, :lead_time_for_150_300_people
    remove_column :vendors, :lead_time_for_300_above_people
    remove_column :vendors, :serviced_events
    remove_column :vendors, :non_serviced_events
    remove_column :vendors, :min_capacity_usd
    add_column :vendors, :vendor_minimum, :float, :default => 100
    add_column :vendors, :concurrent_orders, :integer, :default => 2
    add_column :vendors, :concurrent_orders_time, :integer, :default => 30
    add_column :vendors, :managed_services_lead_time, :decimal, :default => 21
  end
end
