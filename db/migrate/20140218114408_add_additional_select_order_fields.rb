class AddAdditionalSelectOrderFields < ActiveRecord::Migration
  def up
    # select_orders
    add_column :select_orders, :status, :string
    add_column :select_orders, :subtotal_amount_cents, :integer
    add_column :select_orders, :gratuity_amount_cents, :integer
    add_column :select_orders, :delivery_amount_cents, :integer
    add_column :select_orders, :tax_amount_cents, :integer
    add_column :select_orders, :total_amount_cents, :integer

    # inventory_item_select_orders
    add_column :inventory_item_select_orders, :vendor_id, :integer
    add_column :inventory_item_select_orders, :unit_price_cents, :integer

    # inventory_item_option_inventory_item_select_orders
    add_column :inventory_item_option_inventory_item_select_orders, :unit_price_cents, :integer
  end

  def down
    # inventory_item_option_inventory_item_select_orders
    remove_column :inventory_item_option_inventory_item_select_orders, :unit_price_cents

    # inventory_item_select_orders
    remove_column :inventory_item_select_orders, :unit_price_cents
    remove_column :inventory_item_select_orders, :vendor_id

    # select_orders
    remove_column :select_orders, :total_amount_cents
    remove_column :select_orders, :tax_amount_cents
    remove_column :select_orders, :delivery_amount_cents
    remove_column :select_orders, :gratuity_amount_cents
    remove_column :select_orders, :subtotal_amount_cents
    remove_column :select_orders, :status
  end
end
