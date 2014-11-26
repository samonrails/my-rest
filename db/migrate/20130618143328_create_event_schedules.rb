class CreateEventSchedules < ActiveRecord::Migration
  def change
    create_table :event_schedules do |t|
      t.string :schedule
      t.string :product, :limit => 255
      t.string :meal_period, :limit => 255
      t.integer :location_id
      t.integer :days_to_schedule
      t.integer :contact_id
      t.integer :vendor_id
      t.integer :account_id
      t.datetime :event_start_time
      t.datetime :event_end_time
      t.datetime :setup_start_time
      t.datetime :setup_end_time
      t.datetime :schedule_start_date
      t.datetime :schedule_end_date
      t.datetime :pause_start_date
      t.datetime :pause_end_date
      t.datetime :processed_until
      t.integer :created_by_id
      t.integer :menu_template_id
      t.integer :quantity
      t.timestamps
    end

    add_column :events, :event_schedule_id, :integer
  end
end
