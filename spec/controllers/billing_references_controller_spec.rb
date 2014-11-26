require 'spec_helper'

describe BillingReferencesController do

  before(:each) do
    sign_in_user
    @billing_reference ||= FactoryGirl.create :billing_reference_for_account
    @account ||= FactoryGirl.create :account
    @event ||= FactoryGirl.create :event
    request.env['HTTPS'] = 'on'
  end

  describe 'POST /account/:account_id/billing_references' do
    br = {name: 'Department', data: 'IT\r\nFinance\r\n'}

    it 'should not create a billing_reference record without required fields' do
      blank_hash = br
      assert_difference '@account.billing_references.count', 0 do
        request.env['HTTP_REFERER'] = root_path
        post :create, billing_reference: blank_hash.each{|k,v| blank_hash[k] = ''}, account_id: @account.id
      end
      expect_error_message "Error creating Billing reference - Name can't be blank"
    end
  end

  describe 'PUT /account/:account_id/billing_references/:id' do
    br = {name: 'Expense Codes'}
    billing_reference ||= FactoryGirl.create :billing_reference_for_event
    
    it 'should not update a billing_reference record without required fields' do
      blank_hash = br
      request.env['HTTP_REFERER'] = root_path
      post :update, billing_reference: blank_hash.each{|k,v| blank_hash[k] = ''}, event_id: billing_reference.event_id, id: billing_reference.id
      expect_error_message "Error updating Billing reference."
    end
  end

  describe 'DELETE /account/:account_id/billing_references/:id' do
    it 'should destroy a billing reference object' do
      assert_difference 'BillingReference.count', -1 do
        request.env['HTTP_REFERER'] = root_path
        delete :destroy, id: @billing_reference.id, account_id: @billing_reference.account_id
      end
      expect_success_message "Reference deleted."
    end
  end

  describe 'GET /billing_references/:id/get_choices' do
    it 'should fetch billing reference data as JSON' do
      get :get_choices, id: @billing_reference.id, format: :json
      json_array = JSON.parse response.body
      expect(json_array).to eq @billing_reference[:data]
    end
  end
end