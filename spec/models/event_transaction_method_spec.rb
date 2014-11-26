# == Schema Information
#
# Table name: event_transaction_methods
#
#  id                     :integer          not null, primary key
#  transaction_method     :string(255)
#  info1                  :string(255)
#  info2                  :string(255)
#  transaction_card_token :string(255)
#  user_id                :integer
#  party_type             :string(255)
#  party_id               :integer
#

require 'spec_helper'

describe "EventTransactionMethod" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
