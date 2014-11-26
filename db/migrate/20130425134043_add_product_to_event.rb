class AddProductToEvent < ActiveRecord::Migration
  def change
    add_column :events, :product, :string, :limit => 20
  end
end
