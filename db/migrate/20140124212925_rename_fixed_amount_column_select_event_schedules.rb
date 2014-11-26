class RenameFixedAmountColumnSelectEventSchedules < ActiveRecord::Migration
  def up
    rename_column :select_event_schedules, :is_percentage_capped,     :is_subsidy_percentage_capped
    rename_column :select_event_schedules, :percentage_cap, :subsidy_percentage_cap
    rename_column :select_event_schedules, :fixed_amount_cap_cents, :subsidy_percentage_fixed_amount_cap_cents
    rename_column :select_event_schedules, :fixed_amount_cents, :subsidy_fixed_amount_cents
  end

  def down
  end
end
