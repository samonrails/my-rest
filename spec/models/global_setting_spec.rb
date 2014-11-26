# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string(255)      not null
#  value      :text
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe "GlobalSetting" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
