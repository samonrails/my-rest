class AddMarketDefaultTaxRate < ActiveRecord::Migration
  def up
    add_column :markets, :default_tax_rate, :decimal, :null => false, :default => 10.5
  end

  def down
    remove_column :markets, :default_tax_rate
  end
end
