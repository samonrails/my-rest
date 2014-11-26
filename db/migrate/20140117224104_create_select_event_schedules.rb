class CreateSelectEventSchedules < ActiveRecord::Migration
  def change
    create_table :select_event_schedules do |t|
      t.string   :schedule
      t.integer  :ready_and_bagged, :default => 40, :null => false
      t.datetime :delivery_time
      t.datetime :delivery_time_utc  
      t.datetime :ordering_window_start_time
      t.datetime :ordering_window_end_time
      t.datetime :ordering_window_start_time_utc
      t.datetime :ordering_window_end_time_utc
      t.integer  :created_by_id
      t.datetime :created_at
      t.integer  :account_id
      t.integer  :location_id
      t.string   :product
      t.integer  :contact_id
      t.string   :meal_period
      t.integer  :event_schedule_owner_id
      t.string   :gratuity_payer, :default => "user"
      t.integer  :default_gratuity, :default => 10
      t.string   :delivery_fee_payer, :default => "user"
      t.string   :tax_payer, :string, :default => "user"
      t.string   :subsidy, :default => "none"
      t.boolean  :is_percentage_capped, :default => false
      t.integer  :percentage_cap
      t.integer  :fixed_amount_cap_cents
      t.timestamps
    end
  end
end
