class AddGratuityDeliveryTaxSubsidyToSelectEvents < ActiveRecord::Migration
  def change
    add_column :select_events, :gratuity_payer, :string, :default => "user"
    add_column :select_events, :default_gratuity, :integer, :default => 10
    add_column :select_events, :delivery_fee_payer, :string, :default => "user"
    add_column :select_events, :tax_payer, :string, :default => "user"
    add_column :select_events, :subsidy, :string, :default => "none"
    add_column :select_events, :is_percentage_capped, :boolean, :default => false
    add_column :select_events, :percentage_cap, :integer
    add_column :select_events, :fixed_amount_cap_cents, :integer
    
  end
end
