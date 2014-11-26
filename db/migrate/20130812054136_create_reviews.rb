class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :reviewable, polymorphic: true
      t.references :contact
      t.integer :rating
      t.text :content
      t.references :event

      t.timestamps
    end
    add_index :reviews, :reviewable_id
    add_index :reviews, :contact_id
    add_index :reviews, :event_id
  end
end
