require 'spec_helper'

describe AccountsController do

  before(:each) do
    sign_in_user
    @account ||= FactoryGirl.create :account
    request.env['HTTPS'] = 'on'
  end

  describe "GET /accounts" do

    it "should return accounts in an json array" do
      get :index, :format => :json
      json_array = JSON.parse response.body
      expect(json_array.count).to eq (Account.count > 50) ? 50 : Account.count
    end
  end

  describe "GET /accounts/:id" do
    it "should return a specific in an json format" do
      get :show, :id => @account.id, :format => :json
      json_response = JSON.parse response.body
      expect(json_response["name"]).to eq @account.name
    end
  end

  describe "GET /accounts/:id/export_events.xls" do
    it "should export xls file" do
      get :export_events, :id => @account.id, :format => :xls
      expect(response.header["Content-Type"]).to eq "application/xls; charset=utf-8"
      expect(response.header["Content-Disposition"]).to eq "attachment; filename=\"account_events.xls\""
    end
  end

  describe do
    user = FactoryGirl.create :user
    new_account = {:name => "Enbake Consulting", :account_type => "corporate", :account_manager_id => user.id, 
                 :account_exec_id => user.id, :sales_rep_id => user.id, :active => 1, :tax_exempt => 1}
    blank_hash = new_account.dup

    describe "POST /accounts" do
      it "should create an account" do
        assert_difference 'Account.count' do
          post :create, :account => new_account
        end
        expect_redirect_to account_path(assigns(:account))
        expect(flash[:notice]).to eq "Account created."
      end

      it "should not create an account without required parameters" do
        post :create, :account => blank_hash.each{|k,v| blank_hash[k]=""}
        expect_redirect_to accounts_path
        expect(flash[:error]).to eq "Error creating account - Name can't be blank, Account type can't be blank"
      end
    end
    
    describe "PUT /accounts/:id" do
      it "should update an existing account" do
        put :update, :account => new_account.dup.select{|k,v| k == :name}, :id => @account.id
        expect_redirect_to account_path(@account)
        expect(flash[:notice]).to eq "Account updated successfully."
        expect(@account.reload.name).to eq "Enbake Consulting"
      end

      it "should not update an existing account without required parameters" do
        post :update, :account => blank_hash.each{|k,v| blank_hash[k]=""}, :id => @account.id
        expect_redirect_to account_path(@account)
        expect(flash[:error]).to eq "Error updating account - Name can't be blank, Account type can't be blank"
      end
    end

    describe "DELETE /accounts/:id" do
      it "should delete an existing account" do
        assert_difference 'Account.count', -1 do
          delete :destroy, :id => @account.id
        end
        expect(flash[:notice]).to eq "Account deleted."
      end

      it "should not delete an existing account if have some restricted dependents" do
        event_schedule = FactoryGirl.create :event_schedule
        delete :destroy, :id => event_schedule.account.id
        expect(flash[:error]).to eq "Error destorying account - Cannot delete record because of dependent event_schedules"
      end
    end
    
    describe "PUT /account/:id/associate_users" do
      user1 = FactoryGirl.create :user
      user2 = FactoryGirl.create :user

      it "should associate users as members" do
        assert_difference '@account.users.count', 2 do
          put :associate_users, :id => @account.id, :add_users => "#{user1.id},#{user2.id}", :remove_users => ""
        end
      end

      it "should dis-associate users as members" do
       @account.users << user1
        assert_difference '@account.users.count', -1 do
          put :associate_users, :id => @account.id, :add_users => "", :remove_users => "#{user1.id}"
        end
      end
    end
  end
end
