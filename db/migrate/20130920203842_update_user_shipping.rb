class UpdateUserShipping < ActiveRecord::Migration
  def change
    rename_column :users, :default_shipping_id, :default_account_location_id
  end
end
