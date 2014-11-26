class AddMenuTemplateToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :menu_template_id, :integer
  end
end
