class AddCanceledWithin24HoursToEvent < ActiveRecord::Migration
  def change
    add_column :events, :canceled_within_24_hours, :boolean, :null => false, :default => false
  end
end
