class DeleteNotes < ActiveRecord::Migration
  def up
    drop_table "notes"
  end

  def down
    create_table "notes", :force => true do |t|
      t.text    "note_1"
      t.text    "note_2"
      t.integer "event_id"
  end
  end
end
