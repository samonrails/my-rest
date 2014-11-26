class AddAttributesToVoucher < ActiveRecord::Migration
  def change
    add_column :vouchers, :expires_at, :datetime
    add_column :vouchers, :redeemed_at, :datetime
    add_column :vouchers, :redeemed_by_id, :integer
    add_column :vouchers, :status, :string, default: "unused"
  end
end
