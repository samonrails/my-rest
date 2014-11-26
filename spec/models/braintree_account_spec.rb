# == Schema Information
#
# Table name: braintree_accounts
#
#  id            :integer          not null, primary key
#  resource_id   :integer
#  resource_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  braintree_id  :string(255)
#

require 'spec_helper'

describe "BraintreeAccount" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
