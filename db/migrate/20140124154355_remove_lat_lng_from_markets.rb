class RemoveLatLngFromMarkets < ActiveRecord::Migration
  def change
    remove_column :markets, :lat_nw
    remove_column :markets, :lat_ne
    remove_column :markets, :lat_se
    remove_column :markets, :lat_sw
    remove_column :markets, :lng_nw
    remove_column :markets, :lng_ne
    remove_column :markets, :lng_se
    remove_column :markets, :lng_sw
  end
end
