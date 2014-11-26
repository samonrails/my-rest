class AddVendorAndMenuTemplateIdFieldsToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :vendor_id, :integer
    add_column :menus, :menu_template_id, :integer
  end
end
