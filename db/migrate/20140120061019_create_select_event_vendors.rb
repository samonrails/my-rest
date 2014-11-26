class CreateSelectEventVendors < ActiveRecord::Migration
  def up
    create_table    :select_event_vendors do |t|
      t.belongs_to  :select_event
      t.belongs_to  :vendor
      t.integer     :participation
      t.belongs_to  :menu_template
      t.string      :pricing_type
      t.integer     :default_menu_cogs_cents
      t.integer     :default_menu_sell_price_cents
      t.integer     :default_menu_retail_price_cents
      t.datetime    :vendor_billing_summary_sent_at
    end
  end

  def down
  end
end
