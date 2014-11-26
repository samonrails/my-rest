class AddEventDuplicatingSource < ActiveRecord::Migration
  def change
    add_column :events, :duplicated_from_event_id, :integer
  end
end
