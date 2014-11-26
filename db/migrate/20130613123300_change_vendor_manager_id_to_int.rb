class ChangeVendorManagerIdToInt < ActiveRecord::Migration
  def self.up
   execute 'ALTER TABLE vendors ALTER COLUMN vendor_manager_id TYPE integer USING CAST(vendor_manager_id as INTEGER)'
  end

  def self.down
   change_column :vendors, :vendor_manager_id, :string
  end
end