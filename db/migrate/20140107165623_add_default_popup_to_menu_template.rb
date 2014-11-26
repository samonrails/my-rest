class AddDefaultPopupToMenuTemplate < ActiveRecord::Migration
  def change
    add_column :menu_templates, :is_default, :boolean, :default=>false
  end
end
