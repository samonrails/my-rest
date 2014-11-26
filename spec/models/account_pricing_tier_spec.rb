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

require 'spec_helper'

describe AccountPricingTier do
  let (:account_pricing_tier) { create(:account_pricing_tier) }
  let (:account) { create(:account) }
  let (:pricing_tier) { create(:pricing_tier) }

  it "should be valid" do
    account_pricing_tier.should be_valid
  end

  it "should require an account" do
    build(:account_pricing_tier, account: nil, product: "select", pricing_tier: pricing_tier).should_not be_valid
  end

  it "should require a product" do
    build(:account_pricing_tier, account: account, product: nil, pricing_tier: pricing_tier).should_not be_valid
  end

  it "should require a product that contains a string that is actually a product, part 1" do
    build(:account_pricing_tier, account: account, product: "fake_product", pricing_tier: pricing_tier).should_not be_valid
  end

  it "should require a product that contains a string that is actually a product, part 2" do
    build(:account_pricing_tier, account: account, product: "select", pricing_tier: pricing_tier).should be_valid
  end

  it "should require a pricing tier" do
    build(:account_pricing_tier, account: account, product: "select", pricing_tier: nil).should_not be_valid
  end
end
