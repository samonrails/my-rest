# == Schema Information
#
# Table name: menu_template_groups
#
#  id                :integer          not null, primary key
#  menu_template_id  :integer
#  choices_to_select :integer
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe "MenuTemplateGroup" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
