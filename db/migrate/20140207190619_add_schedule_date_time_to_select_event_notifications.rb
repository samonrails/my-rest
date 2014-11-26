class AddScheduleDateTimeToSelectEventNotifications < ActiveRecord::Migration
  def change
    add_column :select_event_campaigns, :scheduled_at, :datetime
    add_column :select_event_campaigns, :scheduled_at_utc, :datetime
  end
end
