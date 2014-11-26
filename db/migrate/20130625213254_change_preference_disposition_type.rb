class ChangePreferenceDispositionType < ActiveRecord::Migration
  def up
    change_column :preferences, :disposition, :text
  end

  def down
    change_column :preferences, :disposition, :string
  end
end
