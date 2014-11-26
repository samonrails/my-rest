class AddYelpIdToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :yelp_id, :string
  end
end
