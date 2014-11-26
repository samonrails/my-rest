# == Schema Information
#
# Table name: pricing_tiers
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  gross_profit :decimal(, )
#

class PricingTier < ApplicationModel

  has_many :account_pricing_tiers, :dependent => :restrict

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :gross_profit

  def to_s
    "#{ name + ' (' + gross_profit.to_s + '%)' }"
  end

  def gross_profit
    read_attribute(:gross_profit) || 0
  end

  def self.find_by_account_and_product account, product
    PricingTier.find(AccountPricingTier.where(:account_id => account.id, :product => product).first().pricing_tier_id)
  end

end