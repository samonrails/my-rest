# == Schema Information
#
# Table name: vendor_insurances
#
#  id                        :integer          not null, primary key
#  building_id               :integer
#  vendor_id                 :integer
#  user_id                   :integer
#  insurance_effective_date  :date
#  insurance_expiration_date :date
#  waiver_subrogation        :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'spec_helper'

describe VendorInsurance do
end