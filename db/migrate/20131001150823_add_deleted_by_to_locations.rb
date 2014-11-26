class AddDeletedByToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :deleted_by_id, :integer
  end
end
