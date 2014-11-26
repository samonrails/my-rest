require 'spec_helper'

describe AccountRolesController do
  
  before(:each) do
    sign_in_user
    @account= FactoryGirl.create(:account)
    @account_role = FactoryGirl.create(:account_role)
    request.env['HTTPS'] = 'on'
  end

  describe "POST 'create'" do
    it "should create account role for" do
      post :create, :account_role => {:user_id => @user.id, :account_id=>@account.id, :role=>"member"}, format: :json
      expect_response_code 201
    end
  end

  describe "DELETE 'destroy'" do
    it "should destroy account role for" do
      request.env["HTTP_REFERER"] = root_url
      expect { delete :destroy, :id => @account_role.id}.to change( AccountRole, :count).by(-1)
    end
  end

  describe "Put 'update'" do
    it "should update account role" do
      put :update , :account_role=> {:role => "member"}, :id => @account_role.id
      @account_role.reload
      expect(@account_role.role).to eq("member")
      expect_response_code 302
      expect_redirect_to("/accounts/#{@account_role.account.id}?selected=membership")
    end
  end

end