class AddAddressToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :address_id, :integer 
  end
end
