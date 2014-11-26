class AddFeedbackStatusToEvents < ActiveRecord::Migration
  def change
    add_column :events, :feedback_status, :string
  end
end
