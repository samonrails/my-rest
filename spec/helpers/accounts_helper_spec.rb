require "spec_helper"

describe AccountsHelper do

  describe "account_tab_name" do
    it "should handle single word names" do
      expect(helper.account_tab_name("events")).to eq("Events")
    end

    it "should handle multiple word names" do
      expect(helper.account_tab_name("event_schedules")).to eq("Event Schedules")
    end
  end

  describe "tab_selected?" do
    before do
      params[:selected] = "events"
    end

    context "active style" do
      context "when selected" do
        it "should return active" do
          expect(helper.tab_selected?("events", :active)).to eq("active")
        end
      end

      context "when not selected" do
        it "should return nil" do
          expect(helper.tab_selected?("somethingelse", :active)).to be_nil
        end
      end
    end

    context "visibility style" do
      context "when selected" do
        it "should return nil" do
          expect(helper.tab_selected?("events", :visibility)).to be_nil
        end
      end

      context "when not selected" do
        it "should return 'display:none;'" do
          expect(helper.tab_selected?("somethingelse", :visibility)).to eq("display: none;")
        end
      end
    end
  end

end
