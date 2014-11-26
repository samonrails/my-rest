class AddRatingTypeToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :rating_type, :string
  end
end
