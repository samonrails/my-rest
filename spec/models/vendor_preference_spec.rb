# == Schema Information
#
# Table name: vendor_preferences
#
#  id              :integer          not null, primary key
#  preference_type :string(255)
#  account_id      :integer
#  location_id     :integer
#  disposition     :string(255)
#  vendor_id       :integer
#

require 'spec_helper'

describe "VendorPreference" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
