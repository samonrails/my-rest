class AddKeys04 < ActiveRecord::Migration
  def change
    add_foreign_key "building_documents", "buildings", :name => "building_documents_building_id_fk"
    add_foreign_key "building_documents", "users", :name => "building_documents_user_id_fk"
    add_foreign_key "capacities", "vendors", :name => "capacities_vendor_id_fk"
    add_foreign_key "line_items", "line_items", :name => "line_items_add_on_parent_id_fk", :column => "add_on_parent_id"
    add_foreign_key "line_items", "line_items", :name => "line_items_opposing_line_item_id_fk", :column => "opposing_line_item_id"
    add_foreign_key "option_groups", "inventory_items", :name => "option_groups_inventory_item_id_fk"
    add_foreign_key "vendor_documents", "users", :name => "vendor_documents_user_id_fk"
    add_foreign_key "vendor_documents", "vendor_insurances", :name => "vendor_documents_vendor_insurance_id_fk"
    add_foreign_key "vendor_insurances", "buildings", :name => "vendor_insurances_building_id_fk"
    add_foreign_key "vendor_insurances", "users", :name => "vendor_insurances_user_id_fk"
    add_foreign_key "vendor_insurances", "vendors", :name => "vendor_insurances_vendor_id_fk"
  end
end
