class AccountReviewsRollup
  include Sidekiq::Worker

  def perform(account_id, product_type)
    Account.find(account_id).do_reviews_calculation product_type
  end
end
