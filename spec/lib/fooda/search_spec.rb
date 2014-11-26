require "spec_helper"

class MockSearchHelper

  def self.perform_search query, options={}
    Array({})
  end

  def self.columns
    [OpenStruct.new(:name=>"blahblah",:type=>"string")]
  end

  include Fooda::Search
  global_site_search :on => [:name], :filter => "things"
end


describe Fooda::Search do
  before(:all) do
    Fooda::Search.models << MockSearchHelper
  end

  it "should perform the search against all the models" do
    Fooda::Search.models.each do |klass|
      klass.should_receive(:perform_search)
    end

    Fooda::Search.perform("needle")
  end

  it "should only perform the search against the specified targets" do
    MockSearchHelper.should_not_receive(:perform_search)
    Fooda::Search.perform("needle", filter:"vendors")
  end

  it "should search across models" do
    tag = rand(36*36).to_s(36) + "abc"
    account = create(:account,:name => "Name #{ tag }")
    vendor = create(:vendor,:name => "Name #{ tag }")

    results = Fooda::Search.perform(tag)

    results.select {|h| h[:id] == account.id || h[:id] == vendor[:id]}.length.should == 2
  end

end
