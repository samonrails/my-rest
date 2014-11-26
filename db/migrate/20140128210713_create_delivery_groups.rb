class CreateDeliveryGroups < ActiveRecord::Migration
  def up
    create_table :delivery_groups do |t|
      t.string :name
      t.text :location_ids
      t.integer :user_id
    end
  end

  def down
    drop_table :delivery_groups
  end
end
