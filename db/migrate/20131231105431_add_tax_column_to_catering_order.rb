class AddTaxColumnToCateringOrder < ActiveRecord::Migration
  def change
    add_column :catering_orders, :tax, :integer
  end
end
