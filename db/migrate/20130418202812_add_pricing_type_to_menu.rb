class AddPricingTypeToMenu < ActiveRecord::Migration
  def up
    add_column :menus, :pricing_type, :string
  end
  def down
    remove_column :menus, :pricing_type, :string
  end
end
