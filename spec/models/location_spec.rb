# == Schema Information
#
# Table name: locations
#
#  id                          :integer          not null, primary key
#  name                        :string(255)
#  location_type               :string(255)
#  expected_participation      :integer
#  privacy                     :string(255)
#  service_event_instructions  :text
#  connectivity_instructions   :text
#  delivery_event_instructions :text
#  building_address_notes      :string(255)
#  contact_id                  :integer
#  account_id                  :integer
#  building_id                 :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  created_by_id               :integer
#  deleted_at                  :datetime
#  deleted_by_id               :integer
#  default_site_fee_cents      :integer
#

require 'spec_helper'

describe "Location" do
  let (:account) { create(:account) }
  let (:building) { create(:building) }
  let (:contact) { create(:contact) }

  describe "Spot" do
    let (:spot_location) { create(:spot_location) }

    it "should be valid" do
      spot_location.should be_valid
    end

    it "should require an account" do
      build(:spot_location, account: nil).should_not be_valid
    end

    it "should require a building" do
      build(:spot_location, building: nil).should_not be_valid
    end
  end


  describe "Delivery" do 
    let (:delivery_location) { create(:delivery_location) }
    
    it "should be valid" do
      delivery_location.should be_valid
    end

    it "should require an account" do
      build(:delivery_location, account: nil).should_not be_valid
    end

    it "should require a building" do
      build(:delivery_location, building: nil).should_not be_valid
    end
  end
end
