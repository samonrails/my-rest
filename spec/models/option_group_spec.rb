# == Schema Information
#
# Table name: option_groups
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  included          :integer
#  max               :integer
#  inventory_item_id :integer
#  required          :integer
#

require 'spec_helper'

describe OptionGroup do
  let (:option_group) { create(:option_group) }

  it "should be valid" do
    option_group.should be_valid
  end

end
