require 'spec_helper'

describe ContactsController do

  before(:each) do
    sign_in_user
    @contact ||= FactoryGirl.create :contact
    request.env['HTTPS'] = 'on'
  end

  it "should create a contact" do
    assert_difference 'Contact.count', +1 do
      post :create, :contact => {:name=> "Mike Palac", :position =>"re", :email => "dummy2601@gmail.com", :phone_number => "9999999999", 
      :mobile_number => "", :fax_number => "", :primary_contact =>"0", :billing_notifications => "0", :event_notifications => "0", 
      :feedback_notifications => "1", :sms => "0", :contact_type => "Internal"}, :account_id => @contact.account
    end
  end

  it "should update a contact" do
    put :update, :contact => {:name => "Charlie Hagenesa", :position =>"Employee", :email => "mugoyal@enbake.com",
    :phone_number =>"635.168.1783", :mobile_number =>"", :fax_number =>"", :primary_contact =>"0", 
    :billing_notifications =>"0", :event_notifications =>"1", :feedback_notifications =>"1", :sms=> "0", 
    :contact_type =>"Internal"},:account_id =>@contact.account , :id =>@contact.id
    expect(@contact.reload.name).to eq "Charlie Hagenesa"
  end

  it "should delete a contact" do
    assert_difference 'Contact.count', -1 do
      delete :destroy, :account_id =>@contact.account , :id =>@contact.id
    end
  end

  it "should restore a contact" do
    contact = @contact
    delete :destroy, :account_id =>contact.account , :id =>contact.id
    assert_difference 'Contact.count', +1 do
      put :restore, :account_id =>contact.account , :id =>contact.id
    end
  end
end
