class AddBillingReferencesToAccounts < ActiveRecord::Migration
  def change
    create_table :billing_references do |t|
      t.belongs_to :account
      t.string :name, :limit => 255
    end
  end
end