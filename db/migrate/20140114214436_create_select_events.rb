class CreateSelectEvents < ActiveRecord::Migration
  def change
    create_table :select_events do |t|
      t.integer :ready_and_bagged, :null => false
      t.datetime :delivery_time
      t.datetime :delivery_time_utc  
	    t.datetime :ordering_window_start_time
  	  t.datetime :ordering_window_end_time
  	  t.datetime :ordering_window_start_time_utc
  	  t.datetime :ordering_window_end_time_utc
  	  t.integer  :created_by_id
  	  t.integer  :deleted_by_id
  	  t.timestamps
    end
  end
end
