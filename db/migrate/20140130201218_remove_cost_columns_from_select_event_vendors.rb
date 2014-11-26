class RemoveCostColumnsFromSelectEventVendors < ActiveRecord::Migration
  def up
  	remove_column :select_event_vendors, :participation
  	remove_column :select_event_vendors, :pricing_type
  	remove_column :select_event_vendors, :default_menu_cogs_cents
  	remove_column :select_event_vendors, :default_menu_sell_price_cents
  	remove_column :select_event_vendors, :default_menu_retail_price_cents
  end

  def down
  end
end
