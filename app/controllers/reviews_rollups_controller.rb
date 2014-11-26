class ReviewsRollupsController < ApplicationController
  authorize_resource
  
  def index
    events = Event.select{|e| Product.find_parent(e.product) == params[:product_type]}
    reviews = Review.find(:all, :conditions => ["reviewable_id in (?) and reviewable_type = ? and additional_event_ratings = ?", events.map(&:id), "Event", params[:level]])
    reviews = reviews.select{|r| r.rating == params[:rating].to_i} if params[:rating]
    rating = params[:rating] ? params[:rating] : []
    if reviews.blank?
      render partial: "/shared/blank_data_pane", locals: {level: params[:level]}
    else
      render partial: "admin/dashboard/data_pane", locals: {reviews: reviews, index: params[:index], rating: rating, event_review_type: params[:level], product_type: params[:product_type]}
    end
  end
  
  def show
    reviews_rollup = ReviewsRollup.find params[:id]
    product_type = reviews_rollup.product_type
    reviews, rating_array = reviews_for_additional_ratings(reviews_rollup, params[:level])
    reviews = reviews.select{|r| r.rating == params[:rating].to_i} if params[:rating]
    rating = params[:rating] ? params[:rating] : []
    reference = reviews_rollup.reference
    unless reviews.blank?
      if params[:level] == "Event Level Food Ratings"
        events = reference.event_vendors.map(&:event).select{|e| Product.find_parent(e.product) == product_type} if reference.class == Vendor
        events = reference.events.select{|e| Product.find_parent(e.product) == product_type} unless reference.class == Vendor
        if rating_array.blank?
          render partial: "/shared/blank_data_pane", locals: {level: params[:level]}
        else
          render partial: "/shared/event_reviews", locals: {reference: reference, level: params[:level], events: events, index: params[:index], product_type: product_type, rating: rating}
        end
      elsif params[:level] == "Aggregate Item Level Food Ratings"
        render partial: "/shared/item_reviews", locals: {reference: reference, level: params[:level], reviews: reviews, index: params[:index], product_type: product_type, rating: rating}
      else
        render partial: "/shared/presentation_reviews", locals: {reference: reference, level: params[:level], reviews: reviews, index: params[:index], product_type: product_type, rating: rating}
      end
    else
      render partial: "/shared/blank_data_pane", locals: {level: params[:level]}
    end
  end
  
  protected
  
  def reviews_for_additional_ratings(reviews_rollup, level)
    case level
      when "Event Level Food Ratings"
        reviews = Review.find(reviews_rollup.event_level_reviews[:reviews])
        rating_array = reviews_rollup.event_level_reviews[:rating_array]
      when "Aggregate Item Level Food Ratings"
        reviews = Review.find(reviews_rollup.item_level_reviews[:reviews])
        rating_array = reviews_rollup.item_level_reviews[:rating_array]
      when "Food Presentation"
        reviews = Review.find(reviews_rollup.food_presentation_reviews[:reviews])
        rating_array = reviews_rollup.food_presentation_reviews[:rating_array]
      when "Order Accuracy"
        reviews = Review.find(reviews_rollup.order_accuracy_reviews[:reviews])
        rating_array = reviews_rollup.order_accuracy_reviews[:rating_array]
      when "On Time Delivery"
        reviews = Review.find(reviews_rollup.delivery_reviews[:reviews])
        rating_array = reviews_rollup.delivery_reviews[:rating_array]
      when "Ease of Ordering"
        reviews = Review.find(reviews_rollup.ease_of_ordering_reviews[:reviews])
        rating_array = reviews_rollup.ease_of_ordering_reviews[:rating_array]
      when "Customer Service"
        reviews = Review.find(reviews_rollup.customer_service_reviews[:reviews])
        rating_array = reviews_rollup.customer_service_reviews[:rating_array]
    end
    return reviews, rating_array
  end
  
end
