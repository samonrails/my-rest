class AddZipCodesToMarket < ActiveRecord::Migration
  def change
    remove_column :markets, :zip
    add_column :markets, :zip_codes, :text
  end
end
