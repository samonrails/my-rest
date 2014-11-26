# == Schema Information
#
# Table name: taggings
#
#  id            :integer          not null, primary key
#  tag_id        :integer
#  taggable_id   :integer
#  taggable_type :string(255)
#  tagger_id     :integer
#  tagger_type   :string(255)
#  context       :string(128)
#  created_at    :datetime
#

require 'spec_helper'

describe "Tagging" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
