require "spec_helper"

describe LocationDocumentsController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/locations/1/location_documents").not_to be_routable
    end

    it "routes to #show" do
      expect(:get => "/locations/1/location_documents/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(:get => "/locations/1/location_documents/1/edit").not_to be_routable
    end

    it "routes to #create" do
      post("/locations/1/location_documents").should route_to("location_documents#create", :location_id => "1")
    end

    it "routes to #update" do
      expect(:put => "/locations/1/location_documents/1").not_to be_routable
    end

    it "routes to #destroy" do
      delete("/locations/1/location_documents/2").should route_to("location_documents#destroy", :location_id => "1", :id => "2")
    end

    it "routes to #download" do
      get("/locations/1/location_documents/2/download").should route_to("location_documents#download", :location_id => "1", :id => "2")
    end

  end
end
