require 'spec_helper'

describe Ability do

  describe 'fooda employee' do
    
    before(:each) do
      @user = FactoryGirl.create(:user, :roles => ['fooda_employee'])
      @ability = Ability.new(@user)
    end
  
    it "should manage homepage, vendors, accounts, events, reports" do
      @ability.should be_able_to(:manage, :homepage)
      @ability.should be_able_to(:manage, :vendors)
      @ability.should be_able_to(:manage, :accounts)
      @ability.should be_able_to(:manage, :events)
      @ability.should be_able_to(:manage, :reports)
    end
  
    it 'should read dashboard' do
      @ability.should be_able_to(:read, :dashboard)
    end
  
    it 'should read dashboard' do
      @ability.should be_able_to(:read, :dashboard)
    end
  
    it 'should create, read, update, destroy' do
      @ability.should be_able_to(:crud, :markets)
    end
    
    it 'should send scheduled emails' do
      @ability.should be_able_to(:send, :scheduled_emails)
    end
    
    it 'should create, index, update, change_password, csv_upload, export_reviews, export_bar_graph_data user' do
      @ability.should be_able_to(:create, :user)
      @ability.should be_able_to(:index, :user)
      @ability.should be_able_to(:update, :user)
      @ability.should be_able_to(:change_password, :user)
      @ability.should be_able_to(:csv_upload, :user)
      @ability.should be_able_to(:export_reviews, :user)
      @ability.should be_able_to(:export_bar_graph_data, :user)
    end
  
    it 'should not manage all' do
      @ability.should_not be_able_to(:manage, :all)
    end
  
    it 'should not manage payments' do
      @ability = Ability.new(@user)
      @ability.should_not be_able_to(:manage, :payments)
    end
  end

  describe "super admin" do
  
    it 'should manage all' do
      @user = FactoryGirl.create(:user, :roles => ['fooda_employee', 'super_admin'])
      @ability = Ability.new(@user)
      @ability.should be_able_to(:manage, :all)
    end
  
  end

  describe "accounting" do
  
    before(:each) do
      @user = FactoryGirl.create(:user, :roles => ['fooda_employee', 'accounting'])
      @ability = Ability.new(@user)
    end
    
    it 'should not manage all' do
      @ability.should_not be_able_to(:manage, :all)
    end
    
    it 'should manage payments' do
      @ability.should be_able_to(:manage, :payments)
    end
  
  end

  describe "foodizen" do
  
    before(:each) do
      @user = FactoryGirl.create(:user, :roles => ['foodizen'])
      @ability = Ability.new(@user)
    end
   
    it 'should read ,update, change password, add card, update card, delete card' do
      @ability.should be_able_to(:read, @user)
      @ability.should be_able_to(:update, @user)
      @ability.should be_able_to(:change_password, @user)
      @ability.should be_able_to(:add_card, @user)
      @ability.should be_able_to(:update_card, @user)
      @ability.should be_able_to(:delete_card, @user)
    end
  
    it 'should toggle favorite' do
      menu_template = FactoryGirl.create(:menu_template)
      @ability.should be_able_to(:toggle_favorite, menu_template)
    end
  
    it 'should read Catering Order' do
      order = FactoryGirl.create(:order, :user_id => @user.id)
      @ability.should be_able_to(:read, order)
    end
  
    it 'should not create, update, destroy, default contact' do
      @contact = FactoryGirl.create(:contact, :user_id => @user.id)
      @ability.should_not be_able_to(:create, Contact.new)
      @ability.should_not be_able_to(:update, @contact)
      @ability.should_not be_able_to(:destroy, @contact)
      @ability.should_not be_able_to(:default, Contact.new)
    end
  
    it 'should not create, update, destroy, default location' do
      @location = FactoryGirl.create(:location, :created_by_id => @user.id)
      @ability.should_not be_able_to(:create, Location.new)
      @ability.should_not be_able_to(:update, @location)
      @ability.should_not be_able_to(:destroy, @location)
    end
  
    it 'should not manage all' do
      @ability.should_not be_able_to(:manage, :all)
    end
    
    it 'should not manage payments' do
      @ability = Ability.new(@user)
      @ability.should_not be_able_to(:manage, :payments)
    end
    
    it "should not manage homepage, vendors, accounts, events, reports" do
      @ability.should_not be_able_to(:manage, :homepage)
      @ability.should_not be_able_to(:manage, :vendors)
      @ability.should_not be_able_to(:manage, :accounts)
      @ability.should_not be_able_to(:manage, :events)
      @ability.should_not be_able_to(:manage, :reports)
    end
  
    it 'should not read dashboard' do
      @ability.should_not be_able_to(:read, :dashboard)
    end
  
    it 'should not read dashboard' do
      @ability.should_not be_able_to(:read, :dashboard)
    end
  
    it 'should not create, read, update, destroy' do
      @ability.should_not be_able_to(:crud, :markets)
    end
    
    it 'should not send scheduled emails' do
      @ability.should_not be_able_to(:send, :scheduled_emails)
    end
    
    it 'should not create, index, update, change_password, csv_upload, export_reviews, export_bar_graph_data user' do
      @ability.should_not be_able_to(:create, :user)
      @ability.should_not be_able_to(:index, :user)
      @ability.should_not be_able_to(:update, :user)
      @ability.should_not be_able_to(:change_password, :user)
      @ability.should_not be_able_to(:csv_upload, :user)
      @ability.should_not be_able_to(:export_reviews, :user)
      @ability.should_not be_able_to(:export_bar_graph_data, :user)
    end
  end

  describe "catering_foodizen" do
  
    before(:each) do
      @user = FactoryGirl.create(:user, :roles => ['foodizen', 'catering_foodizen'])
      @ability = Ability.new(@user)
    end
  
    it 'should create, update, destroy, default contact' do
      @contact = FactoryGirl.create(:contact, :user_id => @user.id)
      @ability.should be_able_to(:create, Contact.new)
      @ability.should be_able_to(:update, @contact)
      @ability.should be_able_to(:destroy, @contact)
      @ability.should be_able_to(:default, Contact.new)
    end
  
    it 'should create, update, destroy, default location' do
      @location = FactoryGirl.create(:location, :created_by_id => @user.id)
      @ability.should be_able_to(:create, Location.new)
      @ability.should be_able_to(:update, @location)
      @ability.should be_able_to(:destroy, @location)
    end
    
  end
  
end