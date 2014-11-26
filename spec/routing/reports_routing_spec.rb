require "spec_helper"

describe ReportsController do
  describe "routing" do

    it "routes to #index" do
      get("/reports").should route_to("reports#index")
    end

    it "routes to #new" do
      expect(:get => "/reports/new").not_to be_routable
    end

    it "routes to #show" do
      expect(:get => "/reports/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(:get => "/reports/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(:post => "/reports").not_to be_routable
    end

    it "routes to #update" do
      expect(:put => "/reports/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(:delete => "/reports/1").not_to be_routable
    end

  end
end
