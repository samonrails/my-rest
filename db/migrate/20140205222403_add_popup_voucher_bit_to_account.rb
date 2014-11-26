class AddPopupVoucherBitToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :active_popup_vouchers, :boolean, :default => true
  end
end
