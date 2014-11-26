class AddColumnsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :min_capacity, :integer, :default => 10
    add_column :vendors, :max_capacity, :integer, :default => 250
    add_column :vendors, :lead_time_for_min_74_people, :decimal, :default => 24
    add_column :vendors, :lead_time_for_75_150_people, :decimal, :default => 48
    add_column :vendors, :lead_time_for_150_above_people, :decimal, :default => 48
    add_column :vendors, :lead_time_for_max, :decimal, :default => 72
    add_column :vendors, :serviced_events, :integer, :default => 1
    add_column :vendors, :non_serviced_events, :integer, :default => 2
  end
end
