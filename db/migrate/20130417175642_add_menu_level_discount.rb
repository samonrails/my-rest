class AddMenuLevelDiscount < ActiveRecord::Migration
    def up
    create_table :menu_level_discounts do |t|
      t.integer :min
      t.integer :max
      t.float :dollars
      t.belongs_to :menu_template
    end
  end

  def down
    drop_table :menu_level_discounts
  end
end
