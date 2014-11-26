class AddMarkets < ActiveRecord::Migration
  def up
    create_table :markets do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :markets
  end
end
