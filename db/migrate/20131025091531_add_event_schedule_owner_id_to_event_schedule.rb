class AddEventScheduleOwnerIdToEventSchedule < ActiveRecord::Migration
  def change
    add_column :event_schedules, :event_schedule_owner_id, :integer
  end
end
