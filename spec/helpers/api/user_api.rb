require 'spec_helper'

describe "users api" do
  before do 

  end

  describe "get a users credit cards" do
    it 'should return standard account pricing tier' do
      get "api/v1/user/#{@user.id}/credit_cards"
      # cogs = Event.calculate_sell_price_using_standard_pricing_tier 9987
      # response.status.should == 200
      # JSON.parse(response.body).should == {'sell_price' => cogs.to_s }
    end
  end

end