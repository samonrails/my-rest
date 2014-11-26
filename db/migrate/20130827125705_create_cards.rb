class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :token
      t.string :nickname

      t.timestamps
    end
  end
end
