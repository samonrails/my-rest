class AddTimezoneToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :timezone, :string
  end
end
