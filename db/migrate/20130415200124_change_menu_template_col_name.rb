class ChangeMenuTemplateColName < ActiveRecord::Migration
  def up
  	rename_column :menu_templates, :menu_pricing, :pricing_type
  end

  def down
  	rename_column :menu_templates, :pricing_type, :menu_pricing
  end
end
