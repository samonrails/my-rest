class AddVouchersPurchasedToEventManagedServiceRollup < ActiveRecord::Migration
  def up
    add_column :event_managed_services_rollups, :vouchers_purchased_cents, :integer
  end
  
  def down
    remove_column :event_managed_services_rollups, :vouchers_purchased_cents
  end
end
