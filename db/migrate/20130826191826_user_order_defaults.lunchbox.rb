# This migration comes from lunchbox (originally 20130826191717)
class UserOrderDefaults < ActiveRecord::Migration
  def up
    add_column :users, :default_shipping_id, :integer
    add_column :users, :default_billing_id, :integer
    add_column :users, :default_contact_id, :integer
  end

  def down
    remove_column :users, :default_shipping_id
    remove_column :users, :default_billing_id
    remove_column :users, :default_contact_id
  end
end
