class RemoveZipCodesFromMarket < ActiveRecord::Migration
  def up
    remove_column :markets, :zip_codes
  end

  def down
    add_column :markets, :zip_codes, :text
  end
end
