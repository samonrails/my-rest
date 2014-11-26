require 'spec_helper'

describe BuildingDocumentsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    sign_in @user
    request.env['HTTPS'] = 'on'
  end

  describe do
    it "should destroy building document" do
      building_document = FactoryGirl.create(:building_document)
      delete :destroy, :id => building_document.id, :building_id => building_document.building.id
      expect_response_code 302
    end
  end

end
