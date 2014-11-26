class FixAssetColumns < ActiveRecord::Migration
  def up
    rename_column :assets, :asset_file_name, :resource_file_name
    rename_column :assets, :asset_content_type, :resource_content_type
    rename_column :assets, :asset_file_size, :resource_file_size
    rename_column :assets, :asset_updated_at, :resource_updated_at
  end

  def down
    rename_column :assets, :resource_file_name, :asset_file_name
    rename_column :assets, :resource_content_type, :asset_content_type
    rename_column :assets, :resource_file_size, :asset_file_size
    rename_column :assets, :resource_updated_at, :asset_updated_at
  end
end
