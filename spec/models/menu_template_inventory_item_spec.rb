# == Schema Information
#
# Table name: menu_template_inventory_items
#
#  id                     :integer          not null, primary key
#  inventory_item_id      :integer
#  menu_template_id       :integer
#  menu_template_group_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'spec_helper'

describe "MenuTemplateInventoryItem" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
