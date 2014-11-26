class AddImageToVendor < ActiveRecord::Migration
 def up
    add_column :vendors, :image_file_name, :string, :null => true
    add_column :vendors, :image_content_type, :string, :null => true
    add_column :vendors, :image_file_size, :integer, :null => true
    add_column :vendors, :image_updated_at, :datetime, :null => true

    remove_column :vendors, :logo
  end
  def down
    remove_column :vendors, :image_file_name
    remove_column :vendors, :image_content_type
    remove_column :vendors, :image_file_size
    remove_column :vendors, :image_updated_at

    add_column :vendors, :string
  end
end
