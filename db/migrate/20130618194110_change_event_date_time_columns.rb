class ChangeEventDateTimeColumns < ActiveRecord::Migration
  def change
    add_column :events, :event_start_time_utc, :datetime
    add_column :events, :event_end_time_utc, :datetime
    add_column :events, :setup_start_time_utc, :datetime
    add_column :events, :setup_end_time_utc, :datetime
  end
end
