class AddSubsidyToSelectOrders < ActiveRecord::Migration
  def change
    add_column :select_orders, :subsidy_amount_cents, :integer  
  end
end
