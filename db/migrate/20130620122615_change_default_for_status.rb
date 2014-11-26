class ChangeDefaultForStatus < ActiveRecord::Migration
  def up
    change_column :issues, :status, :boolean, default: false
  end

  def down
    change_column :issues, :status, :boolean, default: true
  end
end
