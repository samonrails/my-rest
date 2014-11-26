# == Schema Information
#
# Table name: reviews_rollups
#
#  id                        :integer          not null, primary key
#  reference_id              :integer
#  reference_type            :string(255)
#  product_type              :string(255)
#  event_level_reviews       :text
#  item_level_reviews        :text
#  food_presentation_reviews :text
#  order_accuracy_reviews    :text
#  delivery_reviews          :text
#  ease_of_ordering_reviews  :text
#  customer_service_reviews  :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class ReviewsRollup < ApplicationModel
  serialize :event_level_reviews, Hash
  serialize :item_level_reviews, Hash
  serialize :food_presentation_reviews, Hash
  serialize :order_accuracy_reviews, Hash
  serialize :delivery_reviews, Hash
  serialize :ease_of_ordering_reviews, Hash
  serialize :customer_service_reviews, Hash
  
  belongs_to :reference, polymorphic: true
  
end