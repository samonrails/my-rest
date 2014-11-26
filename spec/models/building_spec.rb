# == Schema Information
#
# Table name: buildings
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  insurance_required     :boolean
#  insurance_requirements :string(1000)
#  parking_information    :string(1000)
#  loading_information    :string(1000)
#  site_directions        :string(1000)
#  market_id              :integer
#  address_id             :integer
#  contact_title          :string(255)
#  contact_name           :string(255)
#  contact_phone          :string(255)
#  contact_cell           :string(255)
#  contact_fax            :string(255)
#  contact_email          :string(255)
#  timezone               :string(255)
#  is_approved            :boolean          default(FALSE)
#

require 'spec_helper'

describe Building do
  let (:building) { create(:building) }
  let (:building_with_assets) { create(:building_with_assets) }

  it "should be valid" do
    building.should be_valid
  end

  it "should be able to add images" do
    building.assets.push(create(:asset))
    building.assets.push(create(:asset))
    building.save

    building.assets.count.should == 2
  end

  it "should validate factory girls capability of creating assets for buildings" do
    building_with_assets.assets.count.should == 4
  end

end
