class AddContactsToVendor < ActiveRecord::Migration
  def change
    add_column :contacts, :vendor_id, :integer
  end
end
