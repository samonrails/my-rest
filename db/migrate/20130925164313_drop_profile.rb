class DropProfile < ActiveRecord::Migration
  def up
    drop_table :profiles
  end

  def down
    create_table :profiles do |t|
      t.belongs_to :user
    end
  end
end
