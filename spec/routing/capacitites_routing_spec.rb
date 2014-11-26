require "spec_helper"

describe CapacitiesController do
  describe "routing" do

    it "does not route to #index" do
      expect(:get => "/capacitiess").not_to be_routable
    end

    it "routes to #new" do
      expect(:get => "/capacitiess/new").not_to be_routable
    end

    it "routes to #show" do
      expect(:get => "/capacitiess/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(:get => "/capacitiess/1/edit").not_to be_routable
    end

    it "routes to #create" do
      post("/capacities").should route_to("capacities#create")
    end

    it "routes to #update" do
      put("/capacities/1").should route_to("capacities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/capacitiess/1").not_to be_routable
    end

  end
end
