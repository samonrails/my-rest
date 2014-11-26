class CreateMarketsZipcodes < ActiveRecord::Migration
  def change
    create_table :markets_zip_codes, id: false do |t|
      t.references :market, index: true
      t.references :zip_code, index: true
    end
  end
end
