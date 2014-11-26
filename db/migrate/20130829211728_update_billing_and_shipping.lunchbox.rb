# This migration comes from lunchbox (originally 20130829205717)
class UpdateBillingAndShipping < ActiveRecord::Migration
  def change
    rename_column :lunchbox_shippings, :shipping_address1, :address1
    rename_column :lunchbox_shippings, :shipping_address2, :address2
    rename_column :lunchbox_shippings, :shipping_city,     :city
    rename_column :lunchbox_shippings, :shipping_state,    :state
    rename_column :lunchbox_shippings, :shipping_zip_code, :zip_code

    rename_column :lunchbox_billings, :billing_address1, :address1
    rename_column :lunchbox_billings, :billing_address2, :address2
    rename_column :lunchbox_billings, :billing_city,     :city
    rename_column :lunchbox_billings, :billing_state,    :state
    rename_column :lunchbox_billings, :billing_zip_code, :zip_code

    # This will get modified with braintree credentials are merge in.
    add_column :lunchbox_billings, :credit_card_name, :string
    add_column :lunchbox_billings, :credit_card_type, :string
    add_column :lunchbox_billings, :credit_card_last_4, :string
    add_column :lunchbox_billings, :credit_card_expense_code, :string
  end
end
