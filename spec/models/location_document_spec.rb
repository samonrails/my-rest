# == Schema Information
#
# Table name: location_documents
#
#  id                    :integer          not null, primary key
#  document_file_name    :string(255)
#  document_content_type :string(255)
#  document_file_size    :integer
#  location_id           :integer
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe "LocationDocument" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
