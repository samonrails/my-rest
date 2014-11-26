class CreateEventManagedServicesRollup < ActiveRecord::Migration
  def up
    create_table :event_managed_services_rollups do |t|

      t.integer :revenue_cents
      t.integer :cogs_cents
      t.integer :delivery_charge_to_vendor_cents
      t.integer :total_billing_cents
      t.integer :total_tax_cents
      t.integer :subtotal_cents
      t.integer :gratuity_cents
      t.integer :enterprise_fee_cents

      t.timestamps
    end

    add_column :events, :event_managed_services_rollup_id, :integer
  end

  def down
    drop_table :event_managed_services_rollups

    remove_column :events, :event_managed_services_rollup_id
  end
end

