class AddTaxExemptToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :tax_exempt, :boolean, :null => false, :default => false
  end
end
