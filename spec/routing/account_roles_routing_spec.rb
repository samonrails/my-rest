require "spec_helper"

describe AccountRolesController do
  describe "routing" do

    it "does not route to #index" do
      expect(:get => "/account_roles").not_to be_routable
    end

    it "routes to #new" do
      expect(:get => "/account_roles/new").not_to be_routable
    end

    it "routes to #show" do
      expect(:get => "/account_roles/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(:get => "/account_roles/1/edit").not_to be_routable
    end
    
    it "routes to #create" do
      post("/account_roles").should route_to("account_roles#create")
    end

    it "routes to #update" do
      put("/account_roles/1").should route_to("account_roles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/account_roles/1").should route_to("account_roles#destroy", :id => "1")
    end

  end
end
