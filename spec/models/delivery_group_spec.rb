# == Schema Information
#
# Table name: delivery_groups
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  location_ids :text
#  user_id      :integer
#

require "spec_helper"

describe DeliveryGroup do
  let(:user){ FactoryGirl.create(:user) }
  let(:account){ FactoryGirl.create(:account) }
  let(:location){ FactoryGirl.create(:location) }
  let(:delivery_group){ FactoryGirl.create(:delivery_group, user_id: user.id, location_ids: [location.id]) }

  it "should be valid" do
    expect(delivery_group).to be_valid
  end

  it "should require these attributes" do
    %w(name location_ids).each do |a|
      delivery_group.send("#{a}=", nil)
      expect(delivery_group).to_not be_valid
    end
  end

  it "should order locations" do
    l1 = FactoryGirl.create(:location, account: account)
    l2 = FactoryGirl.create(:location, account: account)
    l3 = FactoryGirl.create(:location, account: account)
    delivery_group.location_ids = [l3.id, l1.id, l2.id]
    expect(delivery_group.locations).to eq([l3, l1, l2])
  end

end
