require 'spec_helper'

describe "ping api", Api do 
  describe 'GET /api/v1/ping' do
    it 'should return pong' do
      get 'api/v1/ping'
      response.status.should == 200
      JSON.parse(response.body).should == {'ping' => 'pong'}
    end
  end
end