module Vendor::ReviewsCalculation

  def trigger_reviews_rollup
    product_types = ['perks','select','managed_services']
    product_types.each do |pt|
      begin
        Sidekiq::Client.enqueue(VendorReviewsRollup, self.id, pt)
      rescue Exception => e
        Rails.logger.info "**** WARNING: Not able to access Sidekiq, rolling up Reviews synchronously"
        do_reviews_calculation pt
      end
    end
  end

  def do_reviews_calculation pt

    Rails.logger.info "**** reviews_rollup - VENDOR ID: " + id.to_s

    reviews_rollup = reviews_rollups.find_or_initialize_by_product_type(pt)
    reviews_rollup.update_attributes!(:event_level_reviews => calculate_event_level_reviews(pt),
                                      :item_level_reviews => calculate_item_level_reviews(pt),
                                      :food_presentation_reviews => calculate_food_presentation_reviews(pt),
                                      :order_accuracy_reviews => calculate_order_accuracy_reviews(pt),
                                      :delivery_reviews => calculate_delivery_reviews(pt))
  end

  private

  def calculate_event_level_reviews pt
    events = event_vendors.map(&:event).select{|e| Product.find_parent(e.product) == pt}
    event_reviews = []
    events.each do |e|
      review = average_rating(e.event_reviews.map(&:rating))
      event_reviews << review.round(0) if review
    end
    reviews = events.map{|e| e.event_reviews.order("created_at")}.flatten
    rating_array = event_reviews
    {reviews: reviews.map(&:id), rating_array: rating_array}
  end

  def calculate_item_level_reviews pt
    inventory_items_for_pt = inventory_items.select{|i| i.inventory_item_product_types.map(&:product_type).include?(pt)}
    reviews = inventory_items_for_pt.map{|i| i.reviews.order("created_at")}.flatten
    rating_array = reviews.map(&:rating)
    {reviews: reviews.map(&:id), rating_array: rating_array}
  end

  def calculate_food_presentation_reviews pt
    vendor_ratings pt, "Food Presentation"
  end

  def calculate_order_accuracy_reviews pt
    vendor_ratings pt, "Order Accuracy"
  end

  def calculate_delivery_reviews pt
    vendor_ratings pt, "On Time Delivery"
  end

  def vendor_ratings pt, level
    if level == "On Time Delivery"
      events = reviews.map(&:reviewable)
    else
      events = event_vendors.map(&:event).select{|e| Product.find_parent(e.product) == pt}
    end
    event_reviews = []
    reviews = []
    events.each do |e|
      reviews_for_presentation = e.event_ratings.select{|e| e.additional_event_ratings == level}
      review = average_rating(reviews_for_presentation.map(&:rating))
      event_reviews << review.round(0) if review
      reviews << reviews_for_presentation.map(&:id)
    end
    rating_array = event_reviews
    {reviews: reviews.flatten, rating_array: rating_array}
  end

  def average_rating(array)
    (array.sum/array.size.to_f).round(1) unless array.empty?
  end
end
