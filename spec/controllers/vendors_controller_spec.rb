require 'spec_helper'

describe VendorsController do

  before(:each) do
    sign_in_user
    request.env['HTTPS'] = 'on'
  end

  describe 'GET /vendors' do

    it "should return vendors in an json array" do
      get :index, :format => :json
      json_array = JSON.parse response.body
      expect(json_array.count).to eq (Vendor.count > 50) ? 50 : Vendor.count
    end
  end

  describe 'POST /vendors' do
    it "should create vendor" do
      assert_difference 'Vendor.count' do
        post :create, :vendor => {:name => "Barbeque Nation", :cuisine_list => "Indian,Vegetarian", 
                                :market_list => "Chicago", :vendor_manager_id => @user.id, 
                                :default_tax_rate => "10"}
      end
      expect_redirect_to vendor_path(assigns :vendor)
    end

    it "should not create vendor if data is missing" do
      post :create, :vendor => {:name => "Buffet Hut"}
      expect_redirect_to vendors_path
      expect(flash[:error]).to eq "Error creating vendor - Cuisine list can't be blank, Market list can't be blank, Vendor manager can't be blank"
    end
  end


  describe "PUT /vendors/:id" do
    vendor = FactoryGirl.create :vendor
    vendor_products = vendor.products
    vendor_product_types = vendor.product_types

    it "should update vendor's data" do
      put :update, :vendor => {:cuisine_list => "Mexican", :default_tax_rate => "5"}, :id => vendor.id
      expect(flash[:notice]).to eq "Vendor updated successfully."
      expect(vendor.reload.cuisine_list).to eq ["Mexican"]
      expect(vendor.reload.default_tax_rate).to eq 5
    end
    
    it "should not update vendor's data with blank fields" do
      put :update, :vendor => {:cuisine_list => "", :default_tax_rate => "5"}, :id => vendor.id
      expect(flash[:error]).to eq "Error updating vendor - Cuisine list can't be blank"
      expect(vendor.reload.cuisine_list).to eq ["Italian"]
    end
    
    it "should enable a product(catering, premium popup gold etc.) for vendor" do
      assert_difference "vendor_products.reload.count", 2 do
        put :update, :vendor => {:product_type_config => {:managed_services => {:status => "active", :catering => "on", :prepaid_popup_gold => "on"}}}, 
                    :id => vendor.id
      end
    end

    it "should update vendor's Billing Address" do
      put :update, :vendor => {:address_attributes => {:address1 => "Plot No. 25", :address2 => "IT-Park",
                                                     :city => "Chandigarh", :state => "PB", :zip_code => "152002",
                                                     :country => "India", :id => vendor.address.id}}, 
                  :id => vendor.id
      expect(flash[:notice]).to eq "Vendor updated successfully."
      expect(vendor.reload.billing_address).to eq "Plot No. 25<br>IT-Park<br>Chandigarh, PB 152002"
    end
  end

  describe 'DELETE /vendors/:id' do
    vendor = FactoryGirl.create :vendor

    it "should destroy an existing Vendor" do
      vendor.menu_templates.delete_all
      assert_difference 'Vendor.count', -1 do
        delete :destroy, :id => vendor.id
      end
      expect_redirect_to vendors_path
    end

    it "should not destroy an existing Vendor if have some restricted dependents" do
      assert_difference 'Vendor.count', 0 do
        delete :destroy, :id => vendor.id
      end
      expect_redirect_to vendor_path(vendor)
      expect(flash[:error]).to eq "Error destroying Vendor - Cannot delete record because of dependent menu_templates"
    end
  end

end