require 'spec_helper'

describe EventsController do
  before(:each) do
    Fooda::Util::create_pricing_tiers unless PricingTier.any?
    sign_in_user
    request.env['HTTPS'] = 'on'
  end

  describe "POST #send_feedback_email" do
    
    it "should send feedback email" do
      @event = FactoryGirl.create(:event)
      request.env["HTTP_REFERER"] = "events/#{@event.id}"
      post :send_feedback_email, :event_id => @event.id
      flash[:notice].should eq("Feedback Email Sent Successfully.")
    end
  
    it "should not send feedback mail" do
      @event = FactoryGirl.create(:event , contact_id: nil)
      request.env["HTTP_REFERER"] = "events/#{@event.id}"
      post :send_feedback_email, :event_id => @event.id
      flash[:notice].should eq("Error occured in sending feedback email.")
    end
  end

  describe "PUT #claim_event" do
    it "should claim an event" do
      @event = FactoryGirl.create(:event)
      @event.event_owner_id.should be nil
      request.env["HTTP_REFERER"] = root_path
      put :claim_event, :id => @event.id
      @event.reload
      @event.event_owner_id.should eq @user.id
      flash[:notice].should eq('Event claimed successfully.')
      response.should redirect_to root_path
    end
    
    it "should not claim an event" do
      @event = FactoryGirl.create(:event_with_owner)
      @event.event_owner_id.should_not be nil
      request.env["HTTP_REFERER"] = root_path
      put :claim_event, :id => @event.id
      flash[:error].should eq('Sorry! The event has already been claimed.')
      response.should redirect_to root_path
    end
  end
    
  describe "GET /events" do
    it "should render 'index' template" do
      get :index
      response.should render_template("index")
    end
  end
    
  describe "GET /events/:id" do
    it "should render 'show' template" do
      event = FactoryGirl.create(:event)
      get :show, :id => event.id
      response.should render_template("show")
    end
  end
  
  describe do
    location = FactoryGirl.create(:location)
    account = location.account
    contact = location.contact
    new_event =  {account_id: account.id, location_id: location.id, contact_id: contact.id,
                  product: "catering", name: "Enbake Event", quantity: "20", meal_period: "lunch",
                  service_style: "drop_off", event_start_time: Time.now, status: "scheduled"}
    blank_hash = new_event.dup
    
    describe "POST /events" do
      it "should create an event" do
        pending("this test randomly fails on circle. IE https://circleci.com/gh/Fooda/SnapPea/3361")
        post :create, :event => new_event
        expect_redirect_to event_path(assigns(:event))
        expect(flash[:notice]).to eq "Event created successfully."
      end
  
      it "should not create an event without required parameters" do
        post :create, :event => blank_hash.each{|k,v| blank_hash[k]=""}
        expect_redirect_to events_url
        expect(flash[:error]).to eq "Error creating event - Account can't be blank, Event start time can't be blank"
      end
 
      it "should have payment method 'On Account'" do
        location = FactoryGirl.create(:location)
        account = location.account
        account.update_attributes(credit_status: "On Account")
        contact = location.contact
        new_event =  {account_id: account.id, location_id: location.id, contact_id: contact.id,
                      product: "catering", name: "Enbake Event", quantity: "20", meal_period: "lunch",
                      service_style: "drop_off", event_start_time: Time.now, status: "scheduled"}
        post :create, :event => new_event
        assigns(:event).event_transaction_method.transaction_method.should eq "on_account"
      end
    end
  
    describe "PUT /events/:id" do
      before(:each) do
        @event ||= FactoryGirl.create(:event)
      end
      
      it "should update an existing event" do
        put :update, :event => {name: "Enbake Consulting", meal_period: "Dinner"}, id: @event.id
        expect_redirect_to event_path(@event)
        expect(flash[:notice]).to eq "Event updated successfully."
        expect(@event.reload.name).to eq "Enbake Consulting"
      end
  
      it "should not update an existing event without required parameters" do
        post :update, :event => blank_hash.each{|k,v| blank_hash[k]=""}, :id => @event.id
        expect_redirect_to event_path(@event)
        expect(flash[:error]).to eq "Error updating event - Account can't be blank, Event start time can't be blank"
      end
    end
    
    describe "DELETE /events/:id" do
      before(:each) do
        @event ||= FactoryGirl.create(:event)
      end
      
      it "should delete an existing event" do
        assert_difference 'Event.count', -1 do
          delete :destroy, :id => @event.id
        end
        expect(flash[:notice]).to eq "Event deleted."
      end
    end
  end
end
