require 'spec_helper'

describe "menu api" do
  before do 
    @menu_template = FactoryGirl.create :menu_template
    @menu_template.update_attributes(cogs: Money.new(9987))

    @account_pricing_tier = FactoryGirl.create :account_pricing_tier 
    @account =  FactoryGirl.create :account
  end

  describe "get menu price for invalid menu template" do
    it "should work" do
      get "api/v1/menu/999999999"
      response.status.should == 404
    end
  end

  describe "get menu price for a guest user" do
    it 'should return standard account pricing tier' do
      get "api/v1/menu/#{@menu_template.id}/sell_price"
      cogs = Event.calculate_sell_price_using_standard_pricing_tier 9987
      response.status.should == 200
      JSON.parse(response.body).should == {'sell_price' => cogs.to_s }
    end
  end

  describe "get menu price for an account pricing tier discount" do 
    it 'should return the account pricing tier' do
      get "api/v1/menu/#{@menu_template.id}/sell_price?account_id=#{@account.id}"
      cogs = CateringPricing.account_pricing_tier_price 9987, @account.id
      response.status.should == 200
      JSON.parse(response.body).should == {'sell_price' => cogs.to_s}
    end
  end
end