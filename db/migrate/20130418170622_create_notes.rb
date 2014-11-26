class CreateNotes < ActiveRecord::Migration
  def up
    create_table :notes do |t|
      t.text :note_1
      t.text :note_2
      t.belongs_to :event
    end
  end

  def down
  end
end
