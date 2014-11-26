class AddSharedFieldToCards < ActiveRecord::Migration
  def change
    add_column :cards, :account_id, :integer
  end
end
