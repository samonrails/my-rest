# == Schema Information
#
# Table name: vendor_products
#
#  id           :integer          not null, primary key
#  product      :string(30)
#  vendor_id    :integer
#  product_type :string(20)
#

class VendorProduct < ApplicationModel
  belongs_to :vendor

  scope :perks, lambda { where(:product_type => "perks") }
  scope :select, lambda { where(:product_type => "perks") }
  scope :managed_services, lambda { where(:product_type => "perks") }
end