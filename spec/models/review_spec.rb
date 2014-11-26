# == Schema Information
#
# Table name: reviews
#
#  id                       :integer          not null, primary key
#  reviewable_id            :integer
#  reviewable_type          :string(255)
#  contact_id               :integer
#  rating                   :integer
#  content                  :text
#  event_id                 :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  rating_type              :string(255)
#  additional_event_ratings :string(255)
#

require 'spec_helper'

describe Review do
end