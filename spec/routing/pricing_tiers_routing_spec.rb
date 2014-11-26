require "spec_helper"

describe PricingTiersController do
  describe "routing" do

    it "routes to #index" do
      get("/pricing_tiers").should route_to("pricing_tiers#index")
    end

    it "routes to #new" do
      get("/pricing_tiers/new").should route_to("pricing_tiers#new")
    end

    it "routes to #show" do
      get("/pricing_tiers/1").should route_to("pricing_tiers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pricing_tiers/1/edit").should route_to("pricing_tiers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pricing_tiers").should route_to("pricing_tiers#create")
    end

    it "routes to #update" do
      put("/pricing_tiers/1").should route_to("pricing_tiers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pricing_tiers/1").should route_to("pricing_tiers#destroy", :id => "1")
    end

  end
end
