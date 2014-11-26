class ChangeGratuitySubsidyCapToNumeric < ActiveRecord::Migration
  def up
    change_column :select_events, :default_gratuity, :decimal, :default => 10
    change_column :select_events, :subsidy_percentage_cap, :decimal
  end

  def down
    change_column :select_events, :default_gratuity, :integer, :default => 10
    change_column :select_events, :subsidy_percentage_cap, :integer
  end
end
