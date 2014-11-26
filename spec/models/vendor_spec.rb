# == Schema Information
#
# Table name: vendors
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  legal_name                 :string(255)
#  description                :text
#  website                    :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  image_file_name            :string(255)
#  image_content_type         :string(255)
#  image_file_size            :integer
#  image_updated_at           :datetime
#  default_tax_rate           :decimal(, )      default(0.0), not null
#  address_id                 :integer
#  vendor_manager_id          :integer
#  bio                        :text
#  rating                     :decimal(2, 1)
#  review_count               :integer
#  rating_image_url           :string(255)
#  yelp_url                   :string(255)
#  yelp_id                    :string(255)
#  vendor_type                :string(255)      default("Restaurant")
#  vendor_minimum             :float            default(100.0)
#  concurrent_orders          :integer          default(2)
#  concurrent_orders_time     :integer          default(30)
#  managed_services_lead_time :decimal(, )      default(21.0)
#  fee                        :float
#  is_fixed                   :boolean          default(FALSE)
#  cap                        :float            default(100.0)
#

require "spec_helper"

describe Vendor do
 
end
