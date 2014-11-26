# == Schema Information
#
# Table name: tokens
#
#  id            :integer          not null, primary key
#  identity_id   :integer
#  identity_type :string(255)
#  digest        :string(255)
#  accessed_at   :datetime
#  expires_at    :datetime
#  data          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Token do
  let(:token) { create(:token) }
  it "has a valid factory" do
    token.should be_valid
  end

  it "should have association with identity" do
    should belong_to(:identity)
  end

  it "should call 'generate_digest' on creation of factory" do
    token = FactoryGirl.create(:token)
    token.digest.should_not be_nil
  end
end