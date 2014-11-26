class AddOptionGroups < ActiveRecord::Migration
  def change
    create_table :option_groups do |t|
      t.string :name
      t.integer :included
      t.integer :max
    end

    create_table :inventory_items_option_groups, :id => false do |t|
      t.belongs_to :inventory_item
      t.belongs_to :option_group
    end

    add_column :inventory_items, :premium_price_cents, :integer, :default => 0, :null => false
    add_column :inventory_items, :add_on, :boolean, :default => false, :null => false
  end
end