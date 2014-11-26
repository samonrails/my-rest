class CreateLocationDefaultSiteFee < ActiveRecord::Migration
  def change
    add_column :locations, :default_site_fee_cents, :integer
  end
end
