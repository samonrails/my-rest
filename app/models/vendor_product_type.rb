# == Schema Information
#
# Table name: vendor_product_types
#
#  id           :integer          not null, primary key
#  vendor_id    :integer
#  product_type :string(20)
#  status       :string(255)      default("inactive")
#

class VendorProductType < ApplicationModel
  belongs_to :vendor

  scope :active, lambda {where(:status=>"active")}
  scope :inactive, lambda {where(:status=>"inactive")}
  scope :onboarding, lambda {where(:status=>"onboarding")}

  def vendor_products
    VendorProduct.where(:product_type=>self.product_type, vendor_id:self.vendor_id)
  end

  def products
    vendor_products
  end
end