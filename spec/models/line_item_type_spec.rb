# == Schema Information
#
# Table name: line_item_types
#
#  id                 :integer          not null, primary key
#  line_item_type     :string(255)
#  line_item_sub_type :string(255)
#  sku                :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe LineItemType do

  let (:line_item_type) { create(:line_item_type)}
  
  it "should be valid" do
    line_item_type.should be_valid
  end

end
