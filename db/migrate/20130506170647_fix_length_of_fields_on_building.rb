class FixLengthOfFieldsOnBuilding < ActiveRecord::Migration
  def up 
    change_table :buildings do |t|
      t.change :insurance_requirements, :string, :limit => 1000
      t.change :parking_information, :string, :limit => 1000
      t.change :loading_information, :string, :limit => 1000
      t.change :site_directions, :string, :limit => 1000
      t.change :contact_title, :string, :limit => 255
      t.change :contact_name, :string, :limit => 255
      t.change :contact_phone, :string, :limit => 255
      t.change :contact_cell, :string, :limit => 255
      t.change :contact_fax, :string, :limit => 255
      t.change :contact_email, :string, :limit => 255

    end
  end

  def down
    change_table :buildings do |t|
      t.change :insurance_requirements, :string, :limit => 255
      t.change :parking_information, :string, :limit => 255
      t.change :loading_information, :string, :limit => 255
      t.change :site_directions, :string, :limit => 255
      t.change :contact_title, :string, :limit => 20
      t.change :contact_name, :string, :limit => 20
      t.change :contact_phone, :string, :limit => 20
      t.change :contact_cell, :string, :limit => 20
      t.change :contact_fax, :string, :limit => 20
      t.change :contact_email, :string, :limit => 20
      end
  end
end
