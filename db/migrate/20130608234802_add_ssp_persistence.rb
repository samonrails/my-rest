class AddSspPersistence < ActiveRecord::Migration
  def change
    create_table :ssp_persistences do |t|
      t.string :ssp_persistence_type
      t.string :name
      t.text :parameters
    end
  end
end
