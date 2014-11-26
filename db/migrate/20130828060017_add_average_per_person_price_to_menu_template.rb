class AddAveragePerPersonPriceToMenuTemplate < ActiveRecord::Migration
  def change
    add_column :menu_templates, :average_per_person_price, :decimal
  end
end
