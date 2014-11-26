class AddEmailNotificationsToSelectEventSchedule < ActiveRecord::Migration
  def change
  	add_column :select_event_schedules, :email_list_id, :string
  	add_column :select_event_schedules, :introduction_email_time, :time 
  	add_column :select_event_schedules, :final_email_time, :time 
  end
end
