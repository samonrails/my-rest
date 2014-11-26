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

require 'spec_helper'

describe PricingTier do
  let (:pricing_tier) { create(:pricing_tier) }

  it "should be valid" do
    pricing_tier.should be_valid
  end
end
