require 'spec_helper' 

describe CapacitiesController do
  
  before(:each) do
    sign_in_user
    @capacity = FactoryGirl.create(:capacity)
    request.env['HTTPS'] = 'on'
  end

  describe "POST 'create'" do
    
    it "should create capacity for" do
      post :create, :vendor_id => @capacity.vendor_id, :capacity => { :day => '1', :start_time => (Time.now + rand(1..10).hours), :end_time => (Time.now + rand(1..10).hours), :is_closed => "0" }
      expect_response_code 302
      expect(flash[:notice]).to eq("Capacity created.")
      expect_redirect_to send("vendor_path".to_sym, @capacity.vendor, :selected => "capacity")
    end

    it "should not create capacity for" do
      post :create, :vendor_id =>@capacity.vendor_id, :capacity => {:day => "1", :start_time => (Time.now + rand(1..10).hours), :is_closed => "0" }
      expect(flash[:error]).to eq("Error creating Capacity.")
      expect_redirect_to send("vendor_path".to_sym, @capacity.vendor, :selected => "capacity")
    end

    it "should not create capacity for" do
      post :create, :vendor_id =>@capacity.vendor_id, :capacity => {:day => "1", :end_time => (Time.now + rand(1..10).hours), :is_closed => "0" }
      expect(flash[:error]).to eq("Error creating Capacity.")
      expect_redirect_to send("vendor_path".to_sym, @capacity.vendor, :selected => "capacity")
    end
  end

  describe "PUT 'update'" do
    it "should update capacity for" do
      put :update, :vendor_id => @capacity.vendor_id, :capacity => { :day => @capacity.day, :start_time => @capacity.start_time, :end_time => @capacity.end_time, :is_closed => @capacity.is_closed}, :id => @capacity.id
      expect_response_code 302
      expect(flash[:notice]).to eq("Changes made successfully!")
      response.should redirect_to send("vendor_path".to_sym, @capacity.vendor, :selected => "capacity")
    end

    it "should not update capacity for" do
      put :update, :vendor_id =>@capacity.vendor_id, :capacity => {:day => @capacity.day, :start_time => @capacity.start_time, :end_time =>"", :is_closed => @capacity.is_closed}, :id => @capacity.id
      expect(flash[:error]).to eq("Error updating capacity - End time can't be blank")
      expect_redirect_to send("vendor_path".to_sym, @capacity.vendor, :selected => "capacity")
    end

    it "should not update capacity for" do
      put :update, :vendor_id =>@capacity.vendor_id, :capacity => {:day => @capacity.day, :start_time =>"", :end_time => @capacity.end_time, :is_closed => @capacity.is_closed}, :id => @capacity.id
      expect(flash[:error]).to eq("Error updating capacity - Start time can't be blank")
      expect_redirect_to send("vendor_path".to_sym, @capacity.vendor, :selected => "capacity")
    end
  end
end