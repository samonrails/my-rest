class ChangeDefaultTaxRateAddDefault < ActiveRecord::Migration
  def up
    change_column :vendors, :default_tax_rate, :decimal, :null => false, :default => 0
  end

  def down
    change_column :vendors, :default_tax_rate, :null => true, :default => nill
  end
end
