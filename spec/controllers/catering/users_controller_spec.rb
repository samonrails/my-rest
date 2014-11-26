require 'spec_helper'
include Devise::TestHelpers

describe Catering::UsersController do
  routes { Catering::Engine.routes }

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    sign_in @user
    request.env['HTTPS'] = 'on'
  end

  describe do

    it "should show user" do
      get :show, :id => @user.id
      expect(response).to be_success
      expect(response).to render_template("show")
    end

    it "should update user information" do
      request.env['HTTP_REFERER'] = root_path
      put :update, :user => {:first_name => "Jason", :last_name => "Willick"}, :id => @user.id
      @user.reload
      @user.first_name.should eq "Jason"
      @user.last_name.should eq "Willick"
    end

    it "should change user's password" do
      put :change_password, :user => {:password => "Tryit123", :password_confirmation => "Tryit123"}, :current_password => "new_passwords", :id => @user.id
      @user.reload
      @user.valid_password?("Tryit123").should be_true
    end

    it "should not change user's password if current password is incorrect" do
      request.env['HTTP_REFERER'] = root_path
      put :change_password, :user => {:password => "Tryit123", :password_confirmation => "Tryit123"}, :current_password => "something_else", :id => @user.id
      @user.reload
       expect_redirect_to root_path
      @user.valid_password?("Tryit123").should be_false
    end

    it "should not change user's password if new password doesn't matches confirmation password" do
      request.env['HTTP_REFERER'] = root_path
      put :change_password, :user => {:password => "Tryit123", :password_confirmation => "Tryit456"}, :current_password => "new_passwords", :id => @user.id
      @user.reload
      response.should redirect_to(root_path)
      @user.valid_password?("Tryit123").should be_false
    end
  end
end