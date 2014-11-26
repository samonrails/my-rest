class CreateReviewsVendors < ActiveRecord::Migration
  def change
    create_table :reviews_vendors, id: false do |t|
      t.references :review
      t.references :vendor
    end
  end
end