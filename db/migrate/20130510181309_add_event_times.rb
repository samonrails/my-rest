class AddEventTimes < ActiveRecord::Migration
  def up
    add_column :events, :setup_date, :date
    add_column :events, :setup_start_time, :time
    add_column :events, :setup_end_time, :time
  end

  def down
    remove_column :events, :setup_date
    remove_column :events, :setup_start_time
    remove_column :events, :setup_end
  end
end
