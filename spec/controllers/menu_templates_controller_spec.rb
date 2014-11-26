require 'spec_helper'

describe MenuTemplatesController do

  before(:each) do
    sign_in_user
    @vendor = FactoryGirl.create :vendor
    request.env['HTTPS'] = 'on'
  end

  describe "GET /vendors/:vendor_id/menu_templates" do
    it "should return vendors in an json array" do
      get :index, :vendor_id => @vendor.id, :format => :json
      json_array = JSON.parse response.body
      expect(json_array.count).to eq @vendor.menu_templates.count
    end
  end

  describe do
    menu_template = {:name => "Non-Veg Fav", :product_type => "managed_services", 
                  :pricing_type => "menu_level", :meal_period_list => "dinner", 
                  :start_date => "27 September 2013", :expiration_date => "30 September 2013", 
                  :is_eligible_for_self_service => "1", :cogs => "20.00", :retail_price => "21.00" }

    describe "POST /vendors/:vendor_id/menu_templates" do

      it "should create menu template" do
        assert_difference 'MenuTemplate.count' do
          post :create, :menu_template => menu_template, :vendor_id => @vendor.id
        end
        expect(flash[:notice]).to eq "Menu Template created successfully."
        expect_redirect_to edit_vendor_menu_template_path(@vendor, assigns(:menu_template))
      end

      it "should not create menu template with blank fields" do
        assert_difference 'MenuTemplate.count', 0 do
          post :create, :menu_template => menu_template.merge(:product_type => "", :start_date => ""), 
                      :vendor_id => @vendor.id
        end
        expect(flash[:error]).to eq "Error creating Menu Template - Start date can't be blank, Product type is not included in the list"
      end

      it "should accept nested attributes for menu level discounts" do
        assert_difference 'MenuLevelDiscount.count', 2 do
          post :create, :menu_template => menu_template.merge(:menu_level_discounts_attributes => [{:min_participation => "10", :cogs => "25.10", :retail_price => "28.17", :_destroy => false}, 
                                                                                   {:min_participation => "12", :cogs => "23.24", :retail_price => "25.80", :_destroy => false}, 
                                                                                   {:min_participation => "14", :cogs => "24.34", :retail_price => "26.84", :_destroy => true}]), 
                      :vendor_id => @vendor.id
        end
      end
    end

    describe "PUT /vendors/:vendor_id/menu_templates/:id" do
      mt = FactoryGirl.create :menu_template

      it "should update any particular menu template" do
        put :update, :menu_template => {:name => "Veg Fav Menu"}, :id => mt.id, :vendor_id => mt.vendor.id
        expect(flash[:notice]).to eq "Menu template updated successfully."
        expect(assigns[:menu_template].name).to eq "Veg Fav Menu"
      end
    end
    
    describe "POST /vendors/:vendor_id/menu_templates/:id/create_menu_group" do
      mt = FactoryGirl.create :menu_template
      it "should create menu template group with selected inventory items" do
        
      end
    end
  end
end