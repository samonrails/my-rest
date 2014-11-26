class AddLockedToSspPersistences < ActiveRecord::Migration
  def change
    add_column :ssp_persistences, :locked, :boolean, :null => false, :default => false
  end
end
