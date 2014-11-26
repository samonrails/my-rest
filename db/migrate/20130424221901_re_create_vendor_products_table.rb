class ReCreateVendorProductsTable < ActiveRecord::Migration
  def up
    create_table :vendor_products, :force => true do |t|
      t.string :product, :limit => 20
      t.integer :vendor_id
    end
  end

  def down
  end
end
