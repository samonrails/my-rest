require 'spec_helper'

  # def reflect_model model, associatied_model
  #   @t = model.reflect_on_association(:associatied_model)
  # end

describe Vendor do
  it "checks vendor associations" do 
    # v = Vendor.reflect_on_all_associations
    # t = Hash[*v.map { |v| [v.macro, v] }.flatten]
    # reflect_model(vendor, inventory_items)
    vm = Vendor.reflect_on_association(:menu_templates)
    vm.macro.should == :has_many
    vm.macro.should == :has_many
  end
end

describe InventoryItem do 
  it "should belong_to a vendor and HABTM :to => :menu_templates" do
    iiv = InventoryItem.reflect_on_association(:vendor)
    iim = InventoryItem.reflect_on_association(:menu_templates)
    iiv.macro.should == :belongs_to
    iim.macro.should == :has_many
  end
end