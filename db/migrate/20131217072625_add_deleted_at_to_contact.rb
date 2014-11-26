class AddDeletedAtToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :deleted_at, :datetime
  end
end
