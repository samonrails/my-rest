class AddUsersToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :created_by_id, :integer
  end
end
