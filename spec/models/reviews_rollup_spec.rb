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

require 'spec_helper'

describe ReviewsRollup do
end