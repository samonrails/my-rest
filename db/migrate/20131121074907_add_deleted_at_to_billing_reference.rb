class AddDeletedAtToBillingReference < ActiveRecord::Migration
  def change
    add_column :billing_references, :deleted_at, :datetime
  end
end
