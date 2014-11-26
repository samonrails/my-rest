class AddFieldsForTaxes < ActiveRecord::Migration
  def up
    add_column :events, :default_tax_rate, :decimal
    add_column :line_items, :tax_rate_expense, :decimal
    add_column :line_items, :tax_rate_revenue, :decimal
  end

  def down
    remove_column :events, :default_tax_rate
    remove_column :line_items, :tax_rate_expense
    remove_column :line_items, :tax_rate_revenue
  end
end
