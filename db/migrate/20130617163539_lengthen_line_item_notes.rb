class LengthenLineItemNotes < ActiveRecord::Migration
  def up
    change_column :line_items, :notes, :text
  end

  def down
    change_column :line_items, :notes, :string
  end
end
