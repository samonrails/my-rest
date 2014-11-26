class AddFieldsToPaymentHistory < ActiveRecord::Migration
  def change
    add_column :payment_histories, :card_type, :string
    add_column :payment_histories, :nickname, :string
    add_column :payment_histories, :exp_date, :string
  end
end
