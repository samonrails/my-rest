class AddAdditionalEventRatingsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :additional_event_ratings, :string
  end
end
