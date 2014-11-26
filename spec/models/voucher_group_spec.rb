# == Schema Information
#
# Table name: voucher_groups
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  cogs_cents          :integer
#  quantity            :integer
#  event_id            :integer
#  order_id            :integer
#  line_item_id        :integer
#  voucher_template_id :integer
#  purcashed_by_id     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  document_id         :integer
#

require 'spec_helper'

describe "VoucherGroup" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
