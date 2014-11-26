class AddDietaryRestrictionsToMenuTemplate < ActiveRecord::Migration
  def change
    add_column :menu_templates, :dietary_restrictions, :text
  end
end
