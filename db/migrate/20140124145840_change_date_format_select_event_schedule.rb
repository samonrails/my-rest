class ChangeDateFormatSelectEventSchedule < ActiveRecord::Migration
  def up
    change_column :select_event_schedules, :delivery_time, :time
    change_column :select_event_schedules, :ordering_window_start_time, :time
    change_column :select_event_schedules, :ordering_window_end_time, :time
    remove_column :select_event_schedules, :ordering_window_start_time_utc
    remove_column :select_event_schedules, :ordering_window_end_time_utc
    remove_column :select_event_schedules, :delivery_time_utc
  end

  def down
    change_column :select_event_schedules, :ordering_window_start_time, :datetime
    change_column :select_event_schedules, :ordering_window_end_time, :datetime
    change_column :select_event_schedules, :delivery_time, :datetime
  end
end
