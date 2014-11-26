class AddKeys03 < ActiveRecord::Migration
  def change
    add_foreign_key "inventory_items_option_groups", "inventory_items", :name => "inventory_items_option_groups_inventory_item_id_fk"
    add_foreign_key "inventory_items_option_groups", "option_groups", :name => "inventory_items_option_groups_option_group_id_fk"
  end
end
