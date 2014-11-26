class AddRatingFieldsToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :rating, :decimal, :precision =>2, :scale =>1
    add_column :vendors, :review_count, :integer
    add_column :vendors, :rating_image_url, :string
    add_column :vendors, :yelp_url, :string
    
  end
end
