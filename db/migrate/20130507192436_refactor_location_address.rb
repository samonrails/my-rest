class RefactorLocationAddress < ActiveRecord::Migration
  def up
    remove_column :locations, :address1
    remove_column :locations, :city
    remove_column :locations, :state
    remove_column :locations, :zip_code
    remove_column :locations, :country

    rename_column :locations, :address2, :building_address_notes

  end

  def down
    add_column :locations, :address1, :string
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :zip_code, :string
    add_column :locations, :country, :string

    rename_column :locations, :building_address_notes, :address2
  end
end
