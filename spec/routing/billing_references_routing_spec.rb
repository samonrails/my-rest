require "spec_helper"

describe BillingReferencesController do
  describe "routing" do

    it "does not route to #index" do
      expect(:get => "/billing_references").not_to be_routable
    end

    it "routes to #new" do
      get("/billing_references/new").should route_to("billing_references#new")
    end

    it "routes to #show" do
      get("/billing_references/1").should route_to("billing_references#show", :id => "1")
    end

    it "routes to #edit" do
      get("/billing_references/1/edit").should route_to("billing_references#edit", :id => "1")
    end

    it "routes to #create" do
      post("/billing_references").should route_to("billing_references#create")
    end

    it "routes to #update" do
      put("/billing_references/1").should route_to("billing_references#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/billing_references/1").should route_to("billing_references#destroy", :id => "1")
    end

  end
end