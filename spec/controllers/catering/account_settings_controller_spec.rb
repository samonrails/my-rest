require 'spec_helper'

describe Catering::AccountSettingsController do
  routes { Catering::Engine.routes }

  describe Catering::AccountSettingsController do
    before(:each) do
      sign_in_user
      @account = FactoryGirl.create :account
      request.env['HTTPS'] = 'on'
    end

    it "should update user's account" do
      put :update , :account => {:name => "abc", :website=> "www.deloitte.com"}, :id => @account.id
      expect(flash[:notice]).to eq "Account updated successfully."
    end

    it "should not update user's account with blank name field" do
        put :update , :account => {:name => nil, :website=> "www.deloitte.com"}, :id => @account.id
      expect(flash[:error]).to eq "Error updating account - Name can't be blank"
    end

    it "should show the account seting's page" do
      get :show , :id => @account.id
      if @account.account_roles.count > 0
        expect_redirect_to account_setting_path(@account)
      end
    end
  end
end
