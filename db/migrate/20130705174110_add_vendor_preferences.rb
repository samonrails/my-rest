class AddVendorPreferences < ActiveRecord::Migration
  def change
    rename_table :preferences, :account_preferences 

    create_table :vendor_preferences do |t| 
      t.string  :preference_type
      t.integer :account_id
      t.integer :location_id
      t.string  :disposition

     t.integer :vendor_id
    end
  end
end
