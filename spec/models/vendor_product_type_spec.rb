# == Schema Information
#
# Table name: vendor_product_types
#
#  id           :integer          not null, primary key
#  vendor_id    :integer
#  product_type :string(20)
#  status       :string(255)      default("inactive")
#

require "spec_helper"

describe VendorProductType do
  let(:vendor_product_type) { create(:vendor_product_type) }
  let(:vendor) { create(:vendor) }

  let(:new_vendor_product_type) do
    create(:vendor_product_type, vendor: vendor)
  end
end
