require 'spec_helper'

describe Catering::BillingReferencesController do
  routes {Catering::Engine.routes}

  before(:each) do
    sign_in_user
    @billing_reference = FactoryGirl.create :billing_reference_for_account
    request.env['HTTPS'] = 'on'
  end
  
  it "should create a new billing reference" do
    request.env['HTTP_REFERER'] = billing_references_path
    post :create, :billing_reference => {:name => "reference1", :required=> "0", :data=> "commercial"}, :account_id => @billing_reference.account.id
    expect(flash[:notice]).to eq "Billing reference created."
    expect_redirect_to billing_references_path
  end
  
  it "should update billing reference" do
    request.env['HTTP_REFERER'] = billing_references_path
    put :update, :billing_reference => {:name => "reference2", :required=> "0", :data=> "residential"}, :account_id => @billing_reference.account.id, :id => @billing_reference.id
    @billing_reference.reload
    expect(flash[:notice]).to eq "Billing reference updated."
    expect_redirect_to billing_references_path
    @billing_reference.data.should eq "residential"
  end
  
  it "should delete billing reference" do
    request.env['HTTP_REFERER'] = billing_references_path
    delete :destroy , :id => @billing_reference.id
    expect(flash[:notice]).to eq "Reference deleted."
    expect_redirect_to billing_references_path
  end
end