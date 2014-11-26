class AddScheduleDatesToSelectEventSchedules < ActiveRecord::Migration
  def change
  	add_column :select_event_schedules, :schedule_start_date, :datetime
  	add_column :select_event_schedules, :schedule_end_date, :datetime
  	add_column :select_event_schedules, :pause_start_date, :datetime
  	add_column :select_event_schedules, :pause_end_date, :datetime
  	add_column :select_event_schedules, :days_to_schedule, :integer
  end
end
