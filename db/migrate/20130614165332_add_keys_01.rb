class AddKeys01 < ActiveRecord::Migration
  def change
    execute 'delete from inventory_item_product_types where id in (select id from inventory_item_product_types where inventory_item_id not in (select id from inventory_items order by id))'
    execute 'delete from event_vendors where id in (select id from event_vendors where event_id not in ( select id from events))'
    execute 'delete from line_items where id in ( select id from line_items where event_id not in ( select id from events))'
    execute 'delete from menu_template_groups where id in (select id from menu_template_groups where menu_template_id not in ( select id from menu_templates))'
    execute 'delete from menu_template_inventory_items where id in (select id from menu_template_inventory_items where inventory_item_id not in ( select id from inventory_items))'
    execute 'delete from vendor_product_types where id in ( select id from vendor_product_types where vendor_id not in ( select id from vendors))'
    execute 'delete from documents where id in ( select id from documents where event_id not in ( select id from events))'
    execute 'delete from menu_level_discounts where id in ( select id from menu_level_discounts where event_vendor_id not in ( select id from event_vendors))'
    add_foreign_key "account_pricing_tiers", "accounts", :name => "account_pricing_tiers_account_id_fk"
    add_foreign_key "account_pricing_tiers", "pricing_tiers", :name => "account_pricing_tiers_pricing_tier_id_fk"
    add_foreign_key "accounts_buildings", "accounts", :name => "accounts_buildings_account_id_fk"
    add_foreign_key "accounts_buildings", "buildings", :name => "accounts_buildings_building_id_fk"
    add_foreign_key "accounts", "users", :name => "accounts_sales_rep_id_fk", :column => "sales_rep_id"
    add_foreign_key "billing_references", "accounts", :name => "billing_references_account_id_fk"
    add_foreign_key "billing_references", "events", :name => "billing_references_event_id_fk"
    add_foreign_key "buildings", "addresses", :name => "buildings_address_id_fk"
    add_foreign_key "buildings", "markets", :name => "buildings_market_id_fk"
    add_foreign_key "contacts", "accounts", :name => "contacts_account_id_fk"
    add_foreign_key "contacts", "vendors", :name => "contacts_vendor_id_fk"
    add_foreign_key "documents", "users", :name => "documents_creator_id_fk", :column => "creator_id"
    add_foreign_key "documents", "events", :name => "documents_event_id_fk"
    add_foreign_key "event_vendors", "events", :name => "event_vendors_event_id_fk"
    add_foreign_key "event_vendors", "event_transaction_methods", :name => "event_vendors_event_transaction_method_id_fk"
    add_foreign_key "event_vendors", "menu_templates", :name => "event_vendors_menu_template_id_fk"
    add_foreign_key "event_vendors", "vendors", :name => "event_vendors_vendor_id_fk"
    add_foreign_key "events", "accounts", :name => "events_account_id_fk"
    add_foreign_key "events", "contacts", :name => "events_contact_id_fk"
    add_foreign_key "events", "users", :name => "events_created_by_id_fk", :column => "created_by_id"
    add_foreign_key "events", "event_transaction_methods", :name => "events_event_transaction_method_id_fk"
    add_foreign_key "events", "locations", :name => "events_location_id_fk"
    add_foreign_key "inventory_item_product_types", "inventory_items", :name => "inventory_item_product_types_inventory_item_id_fk"
    add_foreign_key "inventory_items", "vendors", :name => "inventory_items_vendor_id_fk"
    add_foreign_key "line_items", "documents", :name => "line_items_document_id_fk"
    add_foreign_key "line_items", "events", :name => "line_items_event_id_fk"
    add_foreign_key "line_items", "inventory_items", :name => "line_items_inventory_item_id_fk"
    add_foreign_key "locations", "accounts", :name => "locations_account_id_fk"
    add_foreign_key "locations", "buildings", :name => "locations_building_id_fk"
    add_foreign_key "locations", "contacts", :name => "locations_contact_id_fk"
    add_foreign_key "menu_level_discounts", "event_vendors", :name => "menu_level_discounts_event_vendor_id_fk"
    add_foreign_key "menu_level_discounts", "menu_templates", :name => "menu_level_discounts_menu_template_id_fk"
    add_foreign_key "menu_template_groups", "menu_templates", :name => "menu_template_groups_menu_template_id_fk"
    add_foreign_key "menu_template_inventory_items", "inventory_items", :name => "menu_template_inventory_items_inventory_item_id_fk"
    add_foreign_key "menu_template_inventory_items", "menu_template_groups", :name => "menu_template_inventory_items_menu_template_group_id_fk"
    add_foreign_key "menu_template_inventory_items", "menu_templates", :name => "menu_template_inventory_items_menu_template_id_fk"
    add_foreign_key "profiles", "users", :name => "profiles_user_id_fk"
    add_foreign_key "taggings", "tags", :name => "taggings_tag_id_fk"
    add_foreign_key "vendor_product_types", "vendors", :name => "vendor_product_types_vendor_id_fk"
    add_foreign_key "vendor_products", "vendors", :name => "vendor_products_vendor_id_fk"
    add_foreign_key "vendors", "addresses", :name => "vendors_address_id_fk"
    add_foreign_key "vendors", "users", :name => "vendors_vendor_manager_id_fk", :column => "vendor_manager_id"
    add_foreign_key "menu_templates", "vendors", :name => "menu_templates_vendor_id_fk"
    add_foreign_key "accounts", "addresses", :name => "accounts_address_id_fk"
  end
end
