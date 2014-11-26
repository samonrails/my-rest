require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe SelectEventSchedulesController do
  before(:each) do
      sign_in_user
      @location = FactoryGirl.create(:location)
      @account = @location.account
      @contact = @location.contact
      request.env['HTTPS'] = 'on'
  end
  # This should return the minimal set of attributes required to create a valid
  # SelectEvent. As you add validations to SelectEvent, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { :ready_and_bagged => 50, :delivery_time  => 24.hours.from_now,
                             :ordering_window_start_time => 34.hours.from_now,
                             :ordering_window_end_time => 30.hours.from_now, :days_to_schedule => 14,
                             :schedule_start_date => 48.hours.from_now,
                             :account_id => @account.id, :location_id => @location.id, :contact_id => @contact.id } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SelectEventsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET edit" do
    it "assigns the requested select_event_schedule as @select_event_schedule" do
      select_event_schedule = SelectEventSchedule.create! valid_attributes
      get :edit, {:account_id => @account.id, :id => select_event_schedule.to_param}
      assigns(:select_event_schedule).should eq(select_event_schedule)
    end
  end



  describe "GET new" do
    it "assigns a new select_event_schedule as @select_event_schedule" do
      get :new, {:account_id => @account.id }
      assigns(:account).should eq @account
    end
  end

  describe "POST create" do

   describe "with valid params" do
      it "creates a new SelectEventShedule" do
        expect {
        post :create, {:account_id => @account.id, :select_event_schedule => valid_attributes}
        }.to change(SelectEventSchedule, :count).by(1)
      end

      it "assigns a newly created select_event as @select_event" do
        post :create, {:account_id => @account.id, :select_event_schedule => valid_attributes}
        assigns(:select_event_schedule).should be_a(SelectEventSchedule)
        assigns(:select_event_schedule).should be_persisted
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested select_event_schedule" do
        select_event_schedule = SelectEventSchedule.create! valid_attributes
        expect do
          put :update, {:account_id => @account.id, :id => select_event_schedule.to_param, :select_event_schedule => { "ready_and_bagged" => "600" }}
          select_event_schedule.reload
        end.to change(select_event_schedule, :ready_and_bagged).to(600)
      end
    end

    it "assigns the requested select_event as @select_event" do
      select_event_schedule = SelectEventSchedule.create! valid_attributes
      put :update, {:account_id => @account.id, :id => select_event_schedule.to_param, :select_event_schedule => valid_attributes}
      assigns(:select_event_schedule).should eq(select_event_schedule)
    end

  end



end