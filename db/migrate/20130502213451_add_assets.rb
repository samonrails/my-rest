class AddAssets < ActiveRecord::Migration
  def up
    create_table  :assets do |t|
      t.string    :description
      t.string    :asset_file_name
      t.string    :asset_content_type
      t.integer   :asset_file_size
      t.datetime  :asset_updated_at
      t.string    :owner_type
      t.integer   :owner_id
    end
  end

  def down
    drop_table assets
  end
end
