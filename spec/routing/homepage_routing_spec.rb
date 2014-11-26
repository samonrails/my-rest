require "spec_helper"

describe HomepageController do
  describe "routing" do

    it "routes to #index" do
      get("/homepage").should route_to("homepage#index")
    end

    it "routes to #new" do
      expect(:get => "/homepage/new").not_to be_routable
    end

    it "routes to #show" do
      expect(:get => "/homepage/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(:get => "/homepage/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(:post => "/homepage").not_to be_routable
    end

    it "routes to #update" do
      expect(:put => "/homepage/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(:delete => "/homepage/1").not_to be_routable
    end

  end
end
