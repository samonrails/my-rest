require 'spec_helper'

describe Admin::MarketsController do

  before(:each) do
    sign_in_user
    @market ||= FactoryGirl.create :market
    request.env['HTTPS'] = 'on'
  end

  describe 'POST /admin/markets' do
    market = {:name => "South Delhi", :default_tax_rate => 10.24, :lat_nw => 41.961445, :lng_nw => -87.74848900000001, 
            :lat_ne => 41.969614, :lng_ne => -87.62146, :lat_sw => 41.733829, :lng_sw => -87.741623, 
            :lat_se => 41.738953, :lng_se => -87.52327 }

    it "should create a market record" do
      assert_difference 'Market.count' do
        post :create, :market => market, :zip_codes => "60654"
      end
      expect_redirect_to admin_root_path(:selected => "markets")
      expect_success_message "Market Saved"
    end

    it "should not create a market record without required fields" do
      blank_hash = market.dup
      post :create, :market => blank_hash.each{|k,v| blank_hash[k] = ""}
      expect_redirect_to admin_root_path(:selected => "markets")
      expect_error_message "Error creating Market: Name can't be blank"
    end
  end

  describe 'PUT /admin/markets/:id' do
    it 'should update market record' do
      put :update, :market => {:name => "My Market"}, :zip_codes => "60654", :id => @market.id
      expect_redirect_to admin_root_path(:selected => "markets")
      expect_success_message "Market updated."
      expect(@market.reload.name).to eq "My Market"
    end

    it 'should not update market record without required fields' do
      name = @market.name
      put :update, :market => {:name => ""}, :id => @market.id
      expect_redirect_to admin_root_path(:selected => "markets")
      expect_error_message "Error updating Market: Name can't be blank"
      expect(@market.reload.name).to eq name
    end
  end
  
  describe 'DELETE /admin/markets/:id' do
    it 'should destroy a market record' do
      delete :destroy, :id => @market.id
      expect_success_message "Market deleted."
      expect_redirect_to admin_root_path(:selected => "markets")
    end

    it 'should not destroy a market record if having some dependent records' do
      location = FactoryGirl.create :building
      delete :destroy, :id => location.market.id
      expect_error_message "Error destorying Market: Cannot delete record because of dependent buildings"
      expect_redirect_to admin_root_path(:selected => "markets")
    end
  end
end