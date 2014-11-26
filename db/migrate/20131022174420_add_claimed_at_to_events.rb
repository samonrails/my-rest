class AddClaimedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :claimed_at, :datetime
  end
end
