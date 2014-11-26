# == Schema Information
#
# Table name: event_managed_services_rollups
#
#  id                               :integer          not null, primary key
#  revenue_cents                    :integer
#  cogs_cents                       :integer
#  delivery_charge_to_vendor_cents  :integer
#  total_billing_cents              :integer
#  total_tax_cents                  :integer
#  subtotal_cents                   :integer
#  gratuity_cents                   :integer
#  enterprise_fee_cents             :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  delivery_charge_to_account_cents :integer
#  vouchers_purchased_cents         :integer
#

require 'spec_helper'

describe "EventManagedServicesRollup" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
