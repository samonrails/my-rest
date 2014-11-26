class ChangeProductToMoreCharacters < ActiveRecord::Migration
  def change
    change_column :events, :product, :string, :limit => 30
    change_column :vendor_products, :product, :string, :limit => 30
  end
end
