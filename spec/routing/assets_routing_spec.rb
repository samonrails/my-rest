require "spec_helper"

describe AssetsController do
  describe "routing" do

    it "routes to #index" do
      get("/assets").should route_to("assets#index")
    end

    it "routes to #create" do
      post("/assets").should route_to("assets#create")
    end

    it "routes to #destroy" do
      delete("/assets/1").should route_to("assets#destroy", :id => "1")
    end

    it "routes to #set_default" do
      put("/assets/1/set_default").should route_to("assets#set_default", :id => "1")
    end

  end
end
