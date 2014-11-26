class CreateReviewsRollups < ActiveRecord::Migration
  def change
    create_table :reviews_rollups do |t|
      t.references :reference, polymorphic: true
      t.string :product_type
      t.text :event_level_reviews
      t.text :item_level_reviews
      t.text :food_presentation_reviews
      t.text :order_accuracy_reviews
      t.text :delivery_reviews
      t.text :ease_of_ordering_reviews
      t.text :customer_service_reviews
      t.timestamps
    end
  end
end
