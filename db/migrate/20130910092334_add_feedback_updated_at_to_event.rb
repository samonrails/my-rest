class AddFeedbackUpdatedAtToEvent < ActiveRecord::Migration
  def change
    add_column :events, :feedback_updated_at, :datetime
  end
end
