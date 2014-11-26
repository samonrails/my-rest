class ChangeColumnActiveInAccount < ActiveRecord::Migration
  def change
    change_column :accounts, :active, :boolean, default: true
  end
end
