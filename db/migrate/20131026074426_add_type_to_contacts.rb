class AddTypeToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :contact_type, :string, :default => "Internal"
  end
end
