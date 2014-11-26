class AddExternalTagsToMenuTemplate < ActiveRecord::Migration
  def change
    add_column :menu_templates, :external_tags, :text
  end
end
