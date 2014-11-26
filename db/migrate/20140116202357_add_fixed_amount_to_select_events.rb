class AddFixedAmountToSelectEvents < ActiveRecord::Migration
  def change
    add_column :select_events, :fixed_amount_cents, :integer
  end
end
