class RemoveZoneFromAddress < ActiveRecord::Migration
  def up
    remove_column :addresses, :zone
    remove_column :locations, :zone
  end

  def down
    add_column :addresses, :zone, :string
    add_column :locations, :zone, :string
  end
end
