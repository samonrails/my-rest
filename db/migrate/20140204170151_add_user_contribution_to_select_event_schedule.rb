class AddUserContributionToSelectEventSchedule < ActiveRecord::Migration
  def change
    add_column :select_event_schedules, :user_contribution_required, :boolean, :default => false
    add_column :select_event_schedules, :user_contribution_cents, :integer
  end
end
