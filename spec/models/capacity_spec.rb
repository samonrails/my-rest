# == Schema Information
#
# Table name: capacities
#
#  id         :integer          not null, primary key
#  day        :integer
#  start_time :time
#  end_time   :time
#  is_closed  :boolean          default(FALSE)
#  vendor_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Capacity do
  let (:capacity){ create(:capacity) }

  it "should be a valid" do
    capacity.should be_valid
  end

  it "should belong to Vendor" do
    capacity.should belong_to(:vendor)
  end
end
