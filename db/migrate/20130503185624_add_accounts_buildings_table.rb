class AddAccountsBuildingsTable < ActiveRecord::Migration
  def up
    create_table :accounts_buildings, :id => false do |t|
      t.belongs_to :account
      t.belongs_to :building
    end
  end

  def down
    drop_table :accounts_buildings
  end
end
