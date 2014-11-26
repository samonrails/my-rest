class AddAddress < ActiveRecord::Migration
  def up
    create_table :addresses do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :zone
    end
  end

  def down
    drop_table :addresses
  end
end
