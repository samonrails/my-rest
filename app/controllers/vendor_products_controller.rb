class VendorProductsController < ApplicationController
  authorize_resource
  
  def index
  end

  def new
    @vendor_product = VendorProduct.new
  end

  def create
    @vendor_products = VendorProduct.create(params[:vendor])

    if @vendor_product.save
      flash_and_redirect('Success', root_url)
    else
      flash_and_redirect('Error', root_url)
    end
  end
end
