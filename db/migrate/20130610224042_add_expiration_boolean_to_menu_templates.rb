class AddExpirationBooleanToMenuTemplates < ActiveRecord::Migration
  def change
    add_column :menu_templates, :expires, :boolean
  end
end
