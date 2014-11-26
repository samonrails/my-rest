require "spec_helper"

describe ReviewsRollupsController do
  describe "routing" do

    it "routes to #index" do
      get("/reviews_rollups").should route_to("reviews_rollups#index")
    end

    it "routes to #show" do
      get("/reviews_rollups/1").should route_to("reviews_rollups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/reviews_rollups/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(:post => "/reviews_rollups").not_to be_routable
    end

    it "routes to #update" do
      expect(:put => "/reviews_rollups/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(:delete => "/reviews_rollups/1").not_to be_routable
    end

  end
end
