# == Schema Information
#
# Table name: account_pricing_tiers
#
#  id              :integer          not null, primary key
#  product         :string(255)
#  account_id      :integer
#  pricing_tier_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class AccountPricingTier < ApplicationModel

  belongs_to :account
  belongs_to :pricing_tier

  default_scope order 'product'

  validates_inclusion_of :product, :in => Product.available_values

  validates :account_id, :presence => true
  validates :pricing_tier_id, :presence => true

  validates :account, :associated => true
  validates :pricing_tier, :associated => true

  def to_s
    ""
  end

end