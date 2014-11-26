class Admin::VendorProductTypesController < ApplicationController
  authorize_resource
  respond_to :html

  def index
    respond_with(@vendor_product_types = VendorProductType.all)
  end

  def new
    @vendor_product_type = VendorProductType.new
  end

  def create
    @vendor_product_type = VendorProductType.create(permitted_params.vendor_product_type)

    if @vendor_product_type.save
      flash_and_redirect("Success", root_url)
    else
      flash_and_redirect('Error', root_url)
    end
  end

end
