class AddAccountContactToEvents < ActiveRecord::Migration
  def change
    add_column :events, :contact_id, :integer
  end
end
