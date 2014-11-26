# This migration comes from lunchbox (originally 20130822002453)
class AddLunchboxSession < ActiveRecord::Migration
  def change
    create_table :lunchbox_sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :lunchbox_sessions, :session_id
    add_index :lunchbox_sessions, :updated_at
  end
end
