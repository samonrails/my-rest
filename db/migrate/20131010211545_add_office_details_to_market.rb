class AddOfficeDetailsToMarket < ActiveRecord::Migration
  def change
    add_column :markets, :office_default_phone, :string
    add_column :markets, :office_default_fax, :string
    add_column :markets, :office_default_email, :string

    add_column :markets, :address1, :string
    add_column :markets, :address2, :string
    add_column :markets, :city, :string
    add_column :markets, :state, :string
    add_column :markets, :zip, :string

  end
end
