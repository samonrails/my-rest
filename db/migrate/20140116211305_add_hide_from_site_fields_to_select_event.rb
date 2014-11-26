class AddHideFromSiteFieldsToSelectEvent < ActiveRecord::Migration
  def change
    add_column :select_events, :hide_gratuity_from_site, :boolean, :default => false
    add_column :select_events, :hide_delivery_fee_from_site, :boolean, :default => false
    add_column :select_events, :hide_tax_from_site, :boolean, :default => false
  end
end
