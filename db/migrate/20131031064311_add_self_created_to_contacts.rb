class AddSelfCreatedToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :self_created, :boolean, :default => false
  end
end
