class AddTaxRateLockToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :tax_rate_default_locked_expense, :boolean, :null => false, :default => false
    add_column :line_items, :tax_rate_default_locked_revenue, :boolean, :null => false, :default => false
  end
end
