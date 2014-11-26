class AddBuildings < ActiveRecord::Migration
def up
    create_table :buildings do |t|
      t.string  :name
      t.boolean    :insurance_required
      t.string  :insurance_requirements
      t.string  :parking_information
      t.string  :loading_information
      t.string  :site_directions
      t.belongs_to :market
      t.belongs_to :address
    end
  end

  def down
    drop_table :buildings
  end
end
