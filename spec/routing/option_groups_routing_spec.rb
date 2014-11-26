require "spec_helper"

describe OptionGroupsController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/option_groups").not_to be_routable
    end

    it "routes to #toggle_favorite" do
      post("/option_groups/1/toggle_favorite").should route_to("option_groups#toggle_favorite", :id => "1")
    end

  end
end
