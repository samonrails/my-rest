require 'spec_helper'

describe Catering::Order do
  let (:order) { create(:order) }

  it "should be valid" do
    order.should be_valid
  end

  it "should belong to user, location , contact, event, account " do
    order.should belong_to(:user)
    order.should belong_to(:location)
    order.should belong_to(:contact)
    order.should belong_to(:event)
    order.should belong_to(:account)
  end

  it "should test pretty id method" do
    order.pretty_id.should eq "#{order.id.to_s.rjust(7, "0")}"
  end

  it "should test status method" do
    order.status.should eq order.event.status.titleize
  end
  
  it "should test create_event method" do
    if order.order_builder_dump["catering_order_menus"].length > 0
      unless vendors[MenuTemplate.find(template_id).vendor_id].nil?
        order.single_menu_template?.should eq "You may only choose 1 menu per vendor."
      end
    end
  end
end