class AddUserContributionToSelectEvent < ActiveRecord::Migration
  def change
  	add_column :select_events, :user_contribution_required, :boolean, :default => false
  	add_column :select_events, :user_contribution_cents, :integer
  end
end
