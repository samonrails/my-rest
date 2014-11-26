class AddQuantityToEvent < ActiveRecord::Migration
  def change
    add_column :events, :quantity, :integer
  end
end
