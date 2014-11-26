class AddEventToBillingReferences < ActiveRecord::Migration
  def change
    add_column :billing_references, :event_id, :integer
  end
end
