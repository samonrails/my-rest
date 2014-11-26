class AddSelfServiceToMenuTemplate < ActiveRecord::Migration
  def change
    add_column :menu_templates, :is_eligible_for_self_service, :boolean, :null => false, :default => false
  end
end
