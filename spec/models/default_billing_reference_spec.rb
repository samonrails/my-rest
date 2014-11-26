# == Schema Information
#
# Table name: default_billing_references
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  billing_reference_id :integer
#  choice               :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'spec_helper'

describe "DefaultBillingReference" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
