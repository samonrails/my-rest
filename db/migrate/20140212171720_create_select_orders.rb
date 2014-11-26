class CreateSelectOrders < ActiveRecord::Migration
  def change
    create_table :select_orders do |t|
      t.belongs_to :user
      t.timestamps
    end

    create_table :inventory_item_select_orders do |t|
      t.belongs_to :inventory_item
      t.belongs_to :select_order

      t.integer :quantity
      t.text :special_instructions

      t.timestamps
    end

    create_table :inventory_item_option_inventory_item_select_orders do |t|
      t.belongs_to :inventory_item_select_order
      t.belongs_to :inventory_item_option
      
      t.integer :quantity
      t.text :special_instructions

      t.timestamps
    end
  end
end
