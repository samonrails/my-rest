class MoveDefaultTaxRateFromEventToVendor < ActiveRecord::Migration
  def up
    add_column :vendors, :default_tax_rate, :decimal
    remove_column :events, :default_tax_rate
  end

  def down
    add_column :events, :default_tax_rate, :decimal
    remove_column :vendors, :default_tax_rate
  end
end
