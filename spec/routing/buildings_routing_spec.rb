require "spec_helper"

describe Admin::BuildingsController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/buildings/").not_to be_routable
    end

    it "routes to #new" do
      get("/admin/buildings/new").should route_to("admin/buildings#new")
    end

    it "routes to #show" do
      get("/admin/buildings/1").should route_to("admin/buildings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/buildings/1/edit").should route_to("admin/buildings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/buildings/").should route_to("admin/buildings#create")
    end

    it "routes to #update" do
      put("/admin/buildings/1").should route_to("admin/buildings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/buildings/1").should route_to("admin/buildings#destroy", :id => "1")
    end

  end
end