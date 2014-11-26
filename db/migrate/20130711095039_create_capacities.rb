class CreateCapacities < ActiveRecord::Migration
  def change
    create_table :capacities do |t|
      t.integer :day
      t.time :start_time
      t.time :end_time
      t.boolean :is_closed, default: false
      t.references :vendor

      t.timestamps
    end
  end
end
