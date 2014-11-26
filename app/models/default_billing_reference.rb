# == Schema Information
#
# Table name: default_billing_references
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  billing_reference_id :integer
#  choice               :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class DefaultBillingReference < ApplicationModel
  belongs_to :user
  belongs_to :billing_reference
end