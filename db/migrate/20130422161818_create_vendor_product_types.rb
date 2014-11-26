class CreateVendorProductTypes < ActiveRecord::Migration
  def up
    create_table "vendor_product_types" do |t|
      t.belongs_to :vendor
      t.string :product_type, :limit => 20
      t.string :status, :default => 'inactive'
    end
  end

  def down
    drop_table "vendor_product_types"
  end
end
