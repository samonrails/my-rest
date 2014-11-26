class ChangeFieldsForMultipleEventVendors < ActiveRecord::Migration
  def up
    remove_column :events, :vendor_id
    remove_column :events, :menu_template_id
    remove_column :events, :default_menu_cogs
    remove_column :events, :default_menu_sell_price
    remove_column :events, :pricing_type
    remove_column :events, :event_date
    remove_column :events, :event_time
    add_column :events, :event_datetime, :datetime

    create_table    :event_vendors do |t|
      t.belongs_to  :event
      t.belongs_to  :vendor
      t.integer     :participation
      t.belongs_to  :menu_template
      t.decimal     :default_menu_cogs
      t.decimal     :default_menu_sell_price
      t.string      :pricing_type
    end

    remove_column :menu_level_discounts, :event_id
    add_column    :menu_level_discounts, :event_vendor_id, :integer

  end

  def down
    add_column :events, :vendor_id, :integer
    add_column :events, :menu_template_id, :integer
    add_column :events, :default_menu_cogs, :decimal
    add_column :events, :default_menu_sell_price, :decimal
    add_column :events, :event_date, :date
    add_column :events, :event_time, :string
    remove_column :events, :event_datetime

    drop_table :event_vendors

    add_column :menu_level_discounts, :event_id, :integer
  end
end
