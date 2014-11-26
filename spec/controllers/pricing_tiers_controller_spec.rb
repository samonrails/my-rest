require 'spec_helper'

describe PricingTiersController do

  before(:each) do
    sign_in_user
    @pricing_tier ||= FactoryGirl.create :pricing_tier
    request.env['HTTPS'] = 'on'
  end

  describe 'POST /pricing_tiers' do
    pricing_tier = {:name => "Diamond", :gross_profit => 30.5}

    it 'should create a pricing tier record' do
      assert_difference 'PricingTier.count' do
        post :create, :pricing_tier => pricing_tier
      end
      expect_redirect_to admin_root_path(:selected => "pricing_tiers")
      expect_success_message "PricingTier was created successfully."
    end

    it 'should not create a pricing tier record without required fields' do
      blank_hash = pricing_tier.dup
      post :create, :pricing_tier => blank_hash.each{|k,v| blank_hash[k] = ''}
      expect_redirect_to admin_root_path(:selected => "pricing_tiers")
      expect_error_message "Error creating Pricing Tier: Name can't be blank"
    end
  end

  describe 'PUT /pricing_tiers/:id' do
    it 'should update an existing pricing tier record' do
      name = @pricing_tier.name
      put :update, :pricing_tier => {:name => 'Brass'}, :id => @pricing_tier.id
      expect_redirect_to admin_root_path(:selected => "pricing_tiers")
      expect_success_message "Pricing Tier was updated successfully."
      expect(@pricing_tier.reload.name).to eq 'Brass'
    end

    it 'should not update an existing pricing tier record without required fields' do
      name = @pricing_tier.name
      put :update, :pricing_tier => {:name => ''}, :id => @pricing_tier.id
      expect_redirect_to admin_root_path(:selected => "pricing_tiers")
      expect_error_message "Error updating Pricing Tier: Name can't be blank"
      expect(@pricing_tier.reload.name).to eq name
    end
  end
  
  describe 'DELETE /pricing_tiers/:id' do
    it 'should destroy an existing pricing tier record' do
      assert_difference 'PricingTier.count', -1 do
        delete :destroy, :id => @pricing_tier.id
      end
      expect_redirect_to admin_root_path(:selected => "pricing_tiers")
      expect_success_message "Pricing tier deleted."
    end
    
    it 'should not destroy an exixsting pricing tier record if have some ret stricted dependents' do
      apt = FactoryGirl.create :account_pricing_tier
      assert_difference 'PricingTier.count', 0 do
        delete :destroy, :id => apt.pricing_tier.id
      end
      expect_redirect_to admin_root_path(:selected => "pricing_tiers")
      expect_error_message "Error destorying pricing tier - Cannot delete record because of dependent account_pricing_tiers"
    end
  end
end