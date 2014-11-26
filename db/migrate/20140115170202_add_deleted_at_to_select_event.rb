class AddDeletedAtToSelectEvent < ActiveRecord::Migration
  def change
    add_column :select_events, :deleted_at, :datetime
  end
end
