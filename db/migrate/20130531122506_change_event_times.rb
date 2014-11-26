class ChangeEventTimes < ActiveRecord::Migration
  def up
    remove_column :events, :event_datetime
    remove_column :events, :deliver_time
    remove_column :events, :setup_date
    remove_column :events, :setup_start_time
    remove_column :events, :setup_end_time

    add_column :events, :event_start_time, :datetime
    add_column :events, :event_end_time, :datetime
    add_column :events, :setup_start_time, :datetime
    add_column :events, :setup_end_time, :datetime
  end

  def down
    remove_column :events, :event_start_time
    remove_column :events, :event_end_time
    remove_column :events, :setup_start_time
    remove_column :events, :setup_end_time

    add_column :events, :event_datetime, :datetime
    add_column :events, :deliver_time, :string
    add_column :events, :setup_date, :date
    add_column :events, :setup_start_time, :time
    add_column :events, :setup_end_time, :time
  end
end
