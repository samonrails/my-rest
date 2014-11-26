class AddBioToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :bio, :text
  end
end
