require "spec_helper"

describe TokensController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tokens").not_to be_routable
    end

    it "routes to #new" do
      get("/tokens/new").should route_to("tokens#show", :id => "new")
    end

    it "routes to #show" do
      get("/tokens/abc").should route_to("tokens#show", :id => "abc")
    end

    it "routes to #edit" do
      expect(:get => "/tokens/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(:post => "/tokens").not_to be_routable
    end

    it "routes to #update" do
      expect(:put => "/tokens/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(:delete => "/tokens/1").not_to be_routable
    end

  end
end
