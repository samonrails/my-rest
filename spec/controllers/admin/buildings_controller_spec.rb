require 'spec_helper'

describe Admin::BuildingsController do

  before(:each) do
    sign_in_user
    @building ||=FactoryGirl.create :building
    request.env['HTTPS'] = 'on'
  end

  describe 'POST /admin/buildings' do
    market = FactoryGirl.create :market
    building = {:name => "Enbake Tower", :market_id => market.id, :timezone => "Central Time (US & Canada)", 
              :contact_name => "Mukul", :contact_title => "Mr.", :contact_email => "advaitya@fooda.com", 
              :contact_phone => "(123)456-7890", :contact_cell => "(123)456-7890", :contact_fax => "(123)456-7890", 
              :insurance_required => 0, :insurance_requirements => "", :loading_information => "Information about Loading", 
              :site_directions => "Information about directions", :parking_information => "Information about parking" }

    it "should create a building record" do
      assert_difference 'Building.count' do
        post :create, :building => building
      end
      expect_redirect_to admin_root_path(:selected => "buildings")
      expect_success_message "Building created."
    end

#    it "should not create a building record without required fields" do
#      blank_hash = building.dup
#      post :create, :building => blank_hash.each{|k,v| blank_hash[k] = ""}
#      expect_redirect_to admin_root_path(:selected => "buildings")
#      expect_error_message "Error creating Building  - Name can't be blank, Timezone can't be blank, Market can't be blank"
#    end
  end

  describe 'PUT /admin/buildings/:id' do
    it 'should update building record' do
      put :update, :building => {:name => "My Building"}, :id => @building.id
      expect_redirect_to admin_root_path(:selected => "buildings")
      expect_success_message "Building updated."
      expect(@building.reload.name).to eq "My Building"
    end

#    it 'should not update building record without required fields' do
#      name = @building.name
#      put :update, :building => {:name => ""}, :id => @building.id
#      expect_redirect_to admin_root_path(:selected => "buildings")
#      expect_error_message "Error updating Building  - Name can't be blank"
#      expect(@building.reload.name).to eq name
#    end
  end
  
  describe 'DELETE /admin/buildings/:id' do
    it 'should destroy a building record' do
      delete :destroy, :id => @building.id
      expect_success_message "Building deleted."
      expect_redirect_to admin_root_path(:selected => "buildings")
    end

    it 'should not destroy a building record if having some dependent records' do
      location = FactoryGirl.create :location
      delete :destroy, :id => location.building.id
      expect_error_message "Error destorying Building - Cannot delete record because of dependent locations"
      expect_redirect_to admin_root_path(:selected => "buildings")
    end
  end
end