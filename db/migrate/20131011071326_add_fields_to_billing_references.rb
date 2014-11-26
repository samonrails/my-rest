class AddFieldsToBillingReferences < ActiveRecord::Migration
  def change
    add_column :billing_references, :required, :boolean, default: false
    add_column :billing_references, :data, :text
  end
end
