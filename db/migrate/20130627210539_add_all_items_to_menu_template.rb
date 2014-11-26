class AddAllItemsToMenuTemplate < ActiveRecord::Migration
  def change
    add_column :menu_templates, :all_items, :boolean, :null => false, :default => false
  end
end
