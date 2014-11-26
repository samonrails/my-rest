class VendorReviewsRollup
  include Sidekiq::Worker

  def perform(vendor_id, product_type)
    Vendor.find(vendor_id).do_reviews_calculation product_type
  end
end
