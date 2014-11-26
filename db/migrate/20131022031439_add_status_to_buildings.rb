class AddStatusToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :status, :string, default: :unapproved
  end
end
