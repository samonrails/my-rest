class CreateDefaultBillingReferences < ActiveRecord::Migration
  def change
    create_table :default_billing_references do |t|
      t.references :user
      t.references :billing_reference
      t.string :choice

      t.timestamps
    end
    add_index :default_billing_references, :user_id
    add_index :default_billing_references, :billing_reference_id
  end
end
