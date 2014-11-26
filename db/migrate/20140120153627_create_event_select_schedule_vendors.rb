class CreateEventSelectScheduleVendors < ActiveRecord::Migration
  def up
    create_table    :select_event_schedule_vendors do |t|
      t.belongs_to  :account
      t.belongs_to  :select_event_schedule
      t.belongs_to  :vendor
      t.belongs_to  :menu_template
    end
  end

  def down
  end
end
