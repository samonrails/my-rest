# == Schema Information
#
# Table name: vouchers
#
#  id               :integer          not null, primary key
#  voucher_group_id :integer
#  token            :string(255)
#  expires_at       :datetime
#  redeemed_at      :datetime
#  redeemed_by_id   :integer
#  status           :string(255)      default("unused")
#

require 'spec_helper'

describe "Voucher" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
