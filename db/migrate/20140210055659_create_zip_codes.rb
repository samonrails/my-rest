class CreateZipCodes < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.string :zipcode

      t.timestamps
    end
  end
end
