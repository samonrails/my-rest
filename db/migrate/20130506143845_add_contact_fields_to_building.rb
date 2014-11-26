class AddContactFieldsToBuilding < ActiveRecord::Migration
  def up
    add_column :buildings, :contact_title, :string, :limit => 20
    add_column :buildings, :contact_name, :string, :limit => 20
    add_column :buildings, :contact_phone, :string, :limit => 20
    add_column :buildings, :contact_cell, :string, :limit => 20
    add_column :buildings, :contact_fax, :string, :limit => 20
    add_column :buildings, :contact_email, :string, :limit => 20
  end

  def down
    remove_column :buildings, :contact_title
    remove_column :buildings, :contact_name
    remove_column :buildings, :contact_phone
    remove_column :buildings, :contact_cell
    remove_column :buildings, :contact_fax
    remove_column :buildings, :contact_email
  end
end
