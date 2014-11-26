class FixMenuTemplatesInventoryItemsLinking < ActiveRecord::Migration
  def up
		create_table :inventory_items_menu_templates, :id => false do |t|
			t.belongs_to :inventory_item
			t.belongs_to :menu_template
    end
  end

  def down
  	drop_table :inventory_items_menu_templates
  end
end
