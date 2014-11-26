# == Schema Information
#
# Table name: markets
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  default_tax_rate     :decimal(, )      default(10.5), not null
#  office_default_phone :string(255)
#  office_default_fax   :string(255)
#  office_default_email :string(255)
#  address1             :string(255)
#  address2             :string(255)
#  city                 :string(255)
#  state                :string(255)
#  office_default_sms   :string(255)
#

require 'spec_helper'

describe Market do
  let (:market) { create(:market) }

  it "should be valid" do
    market.should be_valid
  end

  it "should require a name" do
    build(:market, name: nil).should_not be_valid
  end

  it "should require a non empty name" do
    build(:market, name: "").should_not be_valid
  end

end
