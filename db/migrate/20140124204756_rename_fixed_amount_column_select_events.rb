class RenameFixedAmountColumnSelectEvents < ActiveRecord::Migration
  def up
    rename_column :select_events, :is_percentage_capped,     :is_subsidy_percentage_capped
    rename_column :select_events, :percentage_cap, :subsidy_percentage_cap
    rename_column :select_events, :fixed_amount_cap_cents, :subsidy_percentage_fixed_amount_cap_cents
    rename_column :select_events, :fixed_amount_cents, :subsidy_fixed_amount_cents
  end

  def down
  end
end
