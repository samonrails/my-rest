class AddCancellationReasonToEvent < ActiveRecord::Migration
  def change
    add_column :events, :cancellation_reason, :string
  end
end
