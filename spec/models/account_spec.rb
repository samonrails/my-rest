# == Schema Information
#
# Table name: accounts
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  website                   :string(255)
#  account_type              :string(255)
#  active                    :boolean          default(TRUE)
#  address_id                :integer
#  image_file_name           :string(255)
#  image_content_type        :string(255)
#  image_file_size           :integer
#  image_updated_at          :datetime
#  account_exec_id           :integer
#  sales_rep_id              :integer
#  account_manager_id        :integer
#  credit_status             :string(255)      default("Prepay")
#  credit_limit              :decimal(, )      default(0.0)
#  net_days_for_full_payment :integer          default(30)
#  buffer_days               :integer          default(10)
#  tax_exempt                :boolean          default(FALSE), not null
#  active_popup_vouchers     :boolean          default(TRUE)
#

require 'spec_helper'

describe Account do
  let (:account) { create(:account) }

  it "should have many line items" do
    account.should have_many(:line_items)
  end

  it "should be valid" do
    account.should be_valid
  end

  if PricingTier.where(name: "Standard").count == 0
    pt = PricingTier.create!(name: "Standard", gross_profit: 25)
  else
    pt = PricingTier.where(name: "Standard").first()
  end

  Product.available_values.each do |product|
    it "should have a 'Standard' pricing tier link for product " + product do

      apt1 = AccountPricingTier.where(product: product, account_id: account.id)
      apt1.count.should == 1
      apt1.first.pricing_tier_id.should == pt.id
    end
  end
end
