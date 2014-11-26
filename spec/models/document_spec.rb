# == Schema Information
#
# Table name: documents
#
#  id               :integer          not null, primary key
#  document_type    :string(255)
#  recipient        :string(255)
#  total            :string(255)
#  event_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  status           :string(255)
#  name             :string(255)
#  full_file_name   :string(255)
#  creator_id       :integer
#  voucher_group_id :integer
#

require 'spec_helper'

describe "Document" do

  it "should warn us to get off our duffs" do
    pending "fill me out"
  end

end
