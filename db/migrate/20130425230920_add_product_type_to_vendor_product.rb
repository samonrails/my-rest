class AddProductTypeToVendorProduct < ActiveRecord::Migration
  def change
    add_column :vendor_products, :product_type, :string, :limit => 20
  end
end
