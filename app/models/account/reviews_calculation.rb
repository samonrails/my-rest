module Account::ReviewsCalculation

  def trigger_reviews_rollup
    product_types = ["perks", "select", "managed_services"]
    product_types.each do |pt|
      begin
        Sidekiq::Client.enqueue(AccountReviewsRollup, self.id, pt)
      rescue Exception => e
        Rails.logger.info "**** WARNING: Not able to access Sidekiq, rolling up Reviews synchronously"
        do_reviews_calculation pt
      end
    end
  end

  def do_reviews_calculation pt

    Rails.logger.info "**** reviews_rollup - Account ID: " + id.to_s

    reviews_rollup = reviews_rollups.find_or_initialize_by_product_type(pt)
    reviews_rollup.update_attributes!(:event_level_reviews => calculate_event_level_reviews(pt), 
    :item_level_reviews => calculate_item_level_reviews(pt), :food_presentation_reviews => calculate_food_presentation_reviews(pt),
    :order_accuracy_reviews => calculate_order_accuracy_reviews(pt), :delivery_reviews => calculate_delivery_reviews(pt),
    :ease_of_ordering_reviews => calculate_ease_of_ordering_reviews(pt), :customer_service_reviews => calculate_customer_service_reviews(pt))
    
  end

  private

  def calculate_event_level_reviews pt
    account_events = events.select{|e| Product.find_parent(e.product) == pt}
    event_reviews = []
    account_events.each do |e|
      review = average_rating(e.event_reviews.map(&:rating))
      event_reviews << review.round(0) if review
    end
    reviews = events.map{|e| e.event_reviews.order("created_at")}.flatten.map(&:id)
    rating_array = event_reviews
    {reviews: reviews, rating_array: rating_array}
  end

  def calculate_item_level_reviews pt
    inventory_items_for_pt = events.map(&:line_items).flatten.map(&:inventory_item).compact.uniq.select{|i| i.inventory_item_product_types.map(&:product_type).include?(pt)}
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

  def calculate_ease_of_ordering_reviews pt
    vendor_ratings pt, "Ease of Ordering"
  end

  def calculate_customer_service_reviews pt
    vendor_ratings pt, "Customer Service"
  end

  def vendor_ratings pt, level
    events = self.events.select{|e| Product.find_parent(e.product) == pt}
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
