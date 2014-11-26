require "spec_helper"

describe MenuLevelDiscountsController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/menu_level_discounts").not_to be_routable
    end

    it "routes to #new" do
      get("/menu_level_discounts/new").should route_to("menu_level_discounts#new")
    end

    it "routes to #show" do
      expect(:get => "/menu_level_discounts/1").not_to be_routable
    end

    it "routes to #edit" do
      get("/menu_level_discounts/1/edit").should route_to("menu_level_discounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/menu_level_discounts").should route_to("menu_level_discounts#create")
    end

    it "routes to #update" do
      put("/menu_level_discounts/1").should route_to("menu_level_discounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/menu_level_discounts/1").should route_to("menu_level_discounts#destroy", :id => "1")
    end

  end
end
