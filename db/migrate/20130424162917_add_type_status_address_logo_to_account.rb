class AddTypeStatusAddressLogoToAccount < ActiveRecord::Migration
  def up
    add_column :accounts, :website, :string
    add_column :accounts, :account_type, :string
    add_column :accounts, :active, :boolean
    add_column :accounts, :address_id, :integer

    add_column :accounts, :image_file_name, :string, :null => true
    add_column :accounts, :image_content_type, :string, :null => true
    add_column :accounts, :image_file_size, :integer, :null => true
    add_column :accounts, :image_updated_at, :datetime, :null => true
  end
  def down
    remove_column :accounts, :website
    remove_column :accounts, :account_type
    remove_column :accounts, :active
    remove_column :accounts, :address_id

    remove_column :accounts, :image_file_name
    remove_column :accounts, :image_content_type
    remove_column :accounts, :image_file_size
    remove_column :accounts, :image_updated_at
  end
end
