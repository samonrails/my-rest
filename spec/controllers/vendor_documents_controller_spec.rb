require 'spec_helper'

describe VendorDocumentsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    sign_in @user
    request.env['HTTPS'] = 'on'
  end

  describe do
    it "should destroy vendor insurance document" do
      vendor_document = FactoryGirl.create(:vendor_document)
      delete :destroy, :id => vendor_document.id, :vendor_insurance_id => vendor_document.vendor_insurance.id, :vendor_id => vendor_document.vendor_insurance.vendor.id
      expect_response_code 302
    end
  end

end
