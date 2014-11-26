class AddOfficeDefaultSmsToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :office_default_sms, :string
  end
end
