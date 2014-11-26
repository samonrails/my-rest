class AddVendorTypeToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :vendor_type, :string, default: "Restaurant"
  end
end