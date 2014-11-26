# == Schema Information
#
# Table name: menu_level_discounts
#
#  id                 :integer          not null, primary key
#  min_participation  :integer
#  menu_template_id   :integer
#  event_vendor_id    :integer
#  cogs_cents         :integer
#  sell_price_cents   :integer
#  retail_price_cents :integer
#

require "spec_helper"

describe MenuLevelDiscount do
  let(:menu_level_discount) { create(:menu_level_discount) }

  it "should be valid" do
    menu_level_discount.should be_valid
  end
end
