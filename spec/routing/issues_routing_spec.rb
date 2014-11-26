require "spec_helper"

describe IssuesController do
  describe "routing" do

    it "routes to #index" do
      get("/issues").should route_to("issues#index")
    end

    it "routes to #show" do
      get("/issues/1").should route_to("issues#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/issues/1/edit").not_to be_routable
    end

    it "routes to #create" do
      post("/issues").should route_to("issues#create")
    end

    it "routes to #update" do
      put("/issues/1").should route_to("issues#update", :id => "1")
    end

    it "routes to #toggle" do
      get("/issues/1/toggle").should route_to("issues#toggle", :id => "1")
    end

    describe "comments routing" do

      it "routes to #create" do
        post("/issues/1/comments").should route_to("comments#create", :issue_id => "1")
      end
    end
  end
end
