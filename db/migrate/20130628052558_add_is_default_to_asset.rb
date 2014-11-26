class AddIsDefaultToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :is_default, :boolean, :default=>false
  end
end
