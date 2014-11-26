class AddMenuTemplateGroupingTables < ActiveRecord::Migration
  def up
    create_table :menu_template_groups do |t|
      t.belongs_to  :menu_template
      t.integer     :choices_to_select
      t.string      :name
      t.timestamps
    end

    drop_table :inventory_items_menu_templates

    create_table :menu_template_inventory_items do |t|
      t.belongs_to :inventory_item
      t.belongs_to :menu_template
      t.belongs_to :menu_template_group
      t.timestamps
    end

  end

  def down
    drop_table :menu_template_groups
    drop_table :menu_template_inventory_items

    create_table :inventory_items_menu_templates, :id => false do |t|
      t.belongs_to :inventory_item
      t.belongs_to :menu_template

      drop_table :menu_template_inventory_items

    end

  end
end
