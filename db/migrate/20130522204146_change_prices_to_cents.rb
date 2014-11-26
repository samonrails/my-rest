class ChangePricesToCents < ActiveRecord::Migration
  def up
    add_column :event_vendors, :default_menu_cogs_cents, :integer
    add_column :event_vendors, :default_menu_sell_price_cents, :integer
    add_column :event_vendors, :default_menu_retail_price_cents, :integer

    add_column :inventory_items, :cogs_cents, :integer
    add_column :inventory_items, :perks_price_cents, :integer
    add_column :inventory_items, :retail_price_cents, :integer

    add_column :line_items, :unit_price_expense_cents, :integer
    add_column :line_items, :unit_price_revenue_cents, :integer

    add_column :menu_level_discounts, :cogs_cents, :integer
    add_column :menu_level_discounts, :sell_price_cents, :integer
    add_column :menu_level_discounts, :retail_price_cents, :integer

    add_column :menu_templates, :cogs_cents, :integer
    add_column :menu_templates, :sell_price_cents, :integer
    add_column :menu_templates, :retail_price_cents, :integer

    remove_column :event_vendors, :default_menu_cogs
    remove_column :event_vendors, :default_menu_sell_price
    remove_column :event_vendors, :default_menu_retail_price

    remove_column :inventory_items, :cogs
    remove_column :inventory_items, :perks_price
    remove_column :inventory_items, :retail_price

    remove_column :line_items, :unit_price_expense
    remove_column :line_items, :unit_price_revenue

    remove_column :menu_level_discounts, :cogs
    remove_column :menu_level_discounts, :sell_price
    remove_column :menu_level_discounts, :retail_price

    remove_column :menu_templates, :cogs
    remove_column :menu_templates, :sell_price
    remove_column :menu_templates, :retail_price
  end

  def down

    remove_column :event_vendors, :default_menu_cogs_cents
    remove_column :event_vendors, :default_menu_sell_price_cents
    remove_column :event_vendors, :default_menu_retail_price_cents

    remove_column :inventory_items, :cogs_cents
    remove_column :inventory_items, :perks_price_cents
    remove_column :inventory_items, :retail_price_cents

    remove_column :line_items, :unit_price_expense_cents
    remove_column :line_items, :unit_price_revenue_cents

    remove_column :menu_level_discounts, :cogs_cents
    remove_column :menu_level_discounts, :sell_price_cents
    remove_column :menu_level_discounts, :retail_price_cents

    remove_column :menu_templates, :cogs_cents
    remove_column :menu_templates, :sell_price_cents
    remove_column :menu_templates, :retail_price_cents

    add_column :event_vendors, :default_menu_cogs, :decimal
    add_column :event_vendors, :default_menu_sell_price, :decimal
    add_column :event_vendors, :default_menu_retail_price, :decimal

    add_column :inventory_items, :cogs, :decimal
    add_column :inventory_items, :perks_price, :decimal
    add_column :inventory_items, :retail_price, :decimal

    add_column :line_items, :unit_price_expense, :decimal
    add_column :line_items, :unit_price_revenue, :decimal

    add_column :menu_level_discounts, :cogs, :decimal
    add_column :menu_level_discounts, :sell_price, :decimal
    add_column :menu_level_discounts, :retail_price, :decimal

    add_column :menu_templates, :cogs, :decimal
    add_column :menu_templates, :sell_price, :decimal
    add_column :menu_templates, :retail_price, :decimal
  end
end