class CreateVendorInsurances < ActiveRecord::Migration
  def change
    create_table :vendor_insurances do |t|
      t.integer :building_id
      t.integer :vendor_id
      t.integer :user_id
      t.date :insurance_effective_date
      t.date :insurance_expiration_date
      t.string :waiver_subrogation
      t.timestamps
    end
  end
end
