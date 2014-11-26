# == Schema Information
#
# Table name: ssp_persistences
#
#  id                   :integer          not null, primary key
#  ssp_persistence_type :string(255)
#  name                 :string(255)
#  parameters           :text
#  locked               :boolean          default(FALSE), not null
#

require 'spec_helper'

describe "SspPersistence" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
