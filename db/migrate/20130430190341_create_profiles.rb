class CreateProfiles < ActiveRecord::Migration
  def up
    create_table :profiles do |t|
      t.belongs_to :user
    end
  end

  def down
    drop_table :profiles
  end
end
