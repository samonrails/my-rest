class AddLineItem < ActiveRecord::Migration
  def up
    create_table :line_items do |t|
      t.string      :line_item_type
      t.string      :sku
      t.string      :name
      t.string      :notes
      t.integer     :quantity

      t.decimal     :unit_price_expense
      t.decimal     :unit_price_revenue
      t.integer     :entity_expense
      t.integer     :entity_revenue
      t.boolean     :include_price_in_expense
      t.boolean     :include_price_in_revenue

      t.string      :invoice_id
      t.belongs_to  :event
      t.belongs_to  :inventory_item
    end
  end

  def down
    drop_table :line_items
  end
end
