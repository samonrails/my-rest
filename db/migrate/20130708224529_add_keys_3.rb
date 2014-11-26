class AddKeys3 < ActiveRecord::Migration
  def change
    add_foreign_key "account_preferences", "accounts", :name => "account_preferences_account_id_fk"
    add_foreign_key "account_preferences", "vendors", :name => "account_preferences_vendor_id_fk"
    add_foreign_key "vendor_preferences", "accounts", :name => "vendor_preferences_account_id_fk"
    add_foreign_key "vendor_preferences", "locations", :name => "vendor_preferences_location_id_fk"
    add_foreign_key "vendor_preferences", "vendors", :name => "vendor_preferences_vendor_id_fk"
  end
end
