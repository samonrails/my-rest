# == Schema Information
#
# Table name: assets
#
#  id                    :integer          not null, primary key
#  description           :string(255)
#  resource_file_name    :string(255)
#  resource_content_type :string(255)
#  resource_file_size    :integer
#  resource_updated_at   :datetime
#  owner_type            :string(255)
#  owner_id              :integer
#  is_default            :boolean          default(FALSE)
#

require 'spec_helper'

describe Asset do
  let (:building){ create(:building) }
  let (:asset) { create(:asset)}

  it "should be valid" do
    asset.should be_valid
  end

  it "should belong to Payable Party" do
    asset.should belong_to(:owner)
  end

  context "owner" do
    it "should be polymorphic" do
      asset.owner = building;
      asset.owner_id.should == building.id;
      asset.owner_type.should == building.class.name;
    end
  end
end
