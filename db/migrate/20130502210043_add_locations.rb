class AddLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.string  :name
      t.string  :location_type
      t.integer :expected_participation
      t.string  :privacy
      t.text  :service_event_instructions
      t.text  :connectivity_instructions
      t.text  :delivery_event_instructions

      #Address Table Hack
      t.string :address1 
      t.string :address2 
      t.string :city     
      t.string :state    
      t.string :zip_code
      t.string :country  
      t.string :zone

      t.belongs_to :contact
      t.belongs_to :account
      t.belongs_to :building

      t.timestamps
    end
  end

  def down
    drop_table :locations
  end
end
