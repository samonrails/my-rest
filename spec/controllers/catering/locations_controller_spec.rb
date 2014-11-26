require 'spec_helper'

describe Catering::LocationsController do
  routes { Catering::Engine.routes }

  describe LocationsController do
    before(:each) do
      sign_in_user
      @location = FactoryGirl.create :location
      request.env['HTTPS'] = 'on'
    end
    
    it "should update location" do
      request.env['HTTP_REFERER'] = root_path
      put :update , :location => {:id =>@location.id, :name => "loc12", :building_address_notes => "Address 2"}, :id=> @user.id
      @location.reload
      @location.name.should eq "loc12"
    end

    it "should not update location with blank name" do
      request.env['HTTP_REFERER'] = root_path
      put :update , :location => {:id =>@location.id, :name => nil, :building_address_notes => "Address 2"}, :id=> @user.id
      @location.reload
      @location.name.should_not eq nil
    end

    it "should create location" do
      request.env['HTTP_REFERER'] = user_path(@user)
      post :create , :location => {:user_id => @user.id, :name =>"United States",:address1 => "242 Ken Radial" , :address2 => "Suite 393", :city => "Port Astridhaven", :state=> "HI" , :zip_code=> "12502"}
      expect_redirect_to user_path(@user)
    end

    it "should not create location with blank name" do
      request.env['HTTP_REFERER'] = locations_create_building_path
      post :create , :location => {:user_id => @user.id, :name => nil ,:address1 => "242 Ken Radial" , :address2 => "Suite 393", :city => "Port Astridhaven", :state=> "HI" , :zip_code=> "12502"}
      expect_redirect_to locations_create_building_path
    end

    it "should delete location" do
      request.env['HTTP_REFERER'] = root_path
      delete :destroy ,:id => @location.id , :account_role => @user.account_roles.find_by_account_id(@location.account.id)
    end
  end
end

