class AddPreferencesToAccounts < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string  :preference_type
      t.integer :vendor_id
      t.string  :cuisine
      t.string  :disposition

      t.integer :account_id

      t.timestamps
    end
  end
end
