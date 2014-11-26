# == Schema Information
#
# Table name: vendor_documents
#
#  id                    :integer          not null, primary key
#  document_file_name    :string(255)
#  document_content_type :string(255)
#  document_file_size    :integer
#  vendor_insurance_id   :integer
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'

describe VendorDocument do
end