class UnlinkEventAndMenu < ActiveRecord::Migration
  def up
    remove_column :events, :menu_id
    add_column :events, :menu_template_id, :integer
    add_column :events, :pricing_type, :string
    add_column :events, :default_menu_cogs, :decimal
    add_column :events, :default_menu_sell_price, :decimal
    add_column :events, :menu_name, :string

    remove_column :menu_level_discounts, :menu_id
    add_column :menu_level_discounts, :event_id, :integer

    drop_table :menus
    drop_table :menu_items
  end

  def down
    add_column :events, :menu_id, :integer
    remove_column :events, :menu_template_id
    remove_column :events, :pricing_type
    remove_column :events, :default_menu_buy_price
    remove_column :events, :default_menu_sell_price
    remove_column :events, :menu_name

    add_column :menu_level_discounts, :menu_id, :integer
    remove_column :menu_level_discounts, :event_id
  end
end
