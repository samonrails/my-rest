# == Schema Information
#
# Table name: account_preferences
#
#  id              :integer          not null, primary key
#  preference_type :string(255)
#  vendor_id       :integer
#  cuisine         :string(255)
#  disposition     :text
#  account_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe "AccountPreference" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
