require 'spec_helper'

describe AccountPreferencesController do

  before(:each) do
    sign_in_user
    @account ||= FactoryGirl.create :account
    @vendor ||= FactoryGirl.create :vendor
    request.env['HTTPS'] = 'on'
  end

  describe 'POST /account/:account_id/account_preferences' do
    account_pref = {:preference_type => "cuisine", :vendor_id => "", 
                  :cuisine => "Indian", :disposition => "favorite"}

    it 'should create a cuisine preference for a particular account' do
      assert_difference '@account.account_preferences.count' do
        post :create, :account_preference => account_pref,
                     :account_id => @account.id
      end
      expect_redirect_to account_path(@account, :selected => "preferences")
      expect(flash[:notice]).to eq "Preference created."
    end

    it 'should create a vendor preference for a particular account' do
      assert_difference '@account.account_preferences.count' do
        post :create, :account_preference => account_pref.merge(:cuisine => "", :vendor_id => @vendor.id),
                     :account_id => @account.id
      end
      expect_redirect_to account_path(@account, :selected => "preferences")
      expect(flash[:notice]).to eq "Preference created."
    end
    
    it 'should not create account preference without required fields' do
      blank_account_pref = account_pref.dup
      post :create, :account_preference => blank_account_pref.each{|k,v| blank_account_pref[k] = ""},
                   :account_id => @account.id
      expect_redirect_to account_path(@account, :selected => "preferences")
      expect(flash[:error]).to eq "Error creating Preference - Preference type can't be blank, Disposition can't be blank, You must select a Vendor or Cuisine"
    end
  end

  describe 'PUT /account/:account_id/account_preferences/:id' do
    account_preference = FactoryGirl.create :cuisine_account_preferences

    it 'should update an account preference record' do
      put :update, :account_preference => {:cuisine => 'Mexican'}, :id => account_preference.id,
                  :account_id => account_preference.account.id
      expect_redirect_to account_path(account_preference.account, :selected => "preferences")
      expect(flash[:notice]).to eq "Preference updated."
      expect(account_preference.reload.cuisine).to eq 'Mexican'
    end
  end

  describe 'DELETE /account/:account_id/account_preferences/:id' do
    account_preference = FactoryGirl.create :vendor_account_preferences
    account = account_preference.account

    it 'should destroy an account preference record' do
      assert_difference 'account.account_preferences.count', -1 do
        delete :destroy, :id => account_preference.id, :account_id => account.id
      end
      expect_redirect_to account_path(account, :selected => "preferences")
      expect(flash[:notice]).to eq "Preference deleted."
    end
  end
end
