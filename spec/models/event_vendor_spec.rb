# == Schema Information
#
# Table name: event_vendors
#
#  id                              :integer          not null, primary key
#  event_id                        :integer
#  vendor_id                       :integer
#  participation                   :integer
#  menu_template_id                :integer
#  pricing_type                    :string(255)
#  default_menu_cogs_cents         :integer
#  default_menu_sell_price_cents   :integer
#  default_menu_retail_price_cents :integer
#  external_vendor_notes           :text
#  event_transaction_method_id     :integer
#  vendor_billing_summary_sent_at  :datetime
#

require 'spec_helper'

describe "EventVendor" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
