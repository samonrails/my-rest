class AddAccountDeliveryChargesToEventManagedServicesRollup < ActiveRecord::Migration
  def change
    add_column :event_managed_services_rollups, :delivery_charge_to_account_cents, :integer
  end
end
