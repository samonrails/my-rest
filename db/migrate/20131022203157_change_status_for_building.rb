class ChangeStatusForBuilding < ActiveRecord::Migration
  def up
    remove_column :buildings, :status
    add_column :buildings, :is_approved, :boolean, default: false
  end

  def down
    remove_column :buildings, :is_approved
    add_column :buildings, :status, :string, default: :unapproved
  end
end
