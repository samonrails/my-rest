class AddLatLngToMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :lat_nw, :decimal, :default => 0, :null => false
    add_column :markets, :lat_ne, :decimal, :default => 0, :null => false
    add_column :markets, :lat_se, :decimal, :default => 0, :null => false
    add_column :markets, :lat_sw, :decimal, :default => 0, :null => false
    add_column :markets, :lng_nw, :decimal, :default => 0, :null => false
    add_column :markets, :lng_ne, :decimal, :default => 0, :null => false
    add_column :markets, :lng_se, :decimal, :default => 0, :null => false
    add_column :markets, :lng_sw, :decimal, :default => 0, :null => false
  end
end
