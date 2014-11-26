class AddFinanceColumnsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :credit_status, :string, :default => "Prepay"
    add_column :accounts, :credit_limit, :decimal, :default => 0.00
    add_column :accounts, :net_days_for_full_payment, :integer, :default => 30
    add_column :accounts, :buffer_days, :integer, :default => 10
  end
end
