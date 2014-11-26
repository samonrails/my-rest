class AddCuisineToMenuTemplate < ActiveRecord::Migration
  def change
    add_column :menu_templates, :cuisine, :string
  end
end
