class VendorDocumentsController < ApplicationController
  authorize_resource
  
  def new
    @vendor = Vendor.find(params[:vendor_id])
    @vendor_insurance = VendorInsurance.find(params[:vendor_insurance_id])
    @document = VendorDocument.new
  end

  def create
    @vendor = Vendor.find(params[:vendor_id])
    @vendor_insurance = VendorInsurance.find(params[:vendor_insurance_id])
    @vendor_document = VendorDocument.new(post_params)
    @vendor_document.vendor_insurance_id = @vendor_insurance.id
    @vendor_document.user_id = current_user.id
    if @vendor_document.save
      flash[:notice] = "Vendor Insurance created succesfully."
      redirect_to edit_vendor_vendor_insurance_path(@vendor,@vendor_insurance)
    else
      flash[:error] = "Error creating Vendor Document - " + @vendor_document.errors.full_messages.join(", ")
      redirect_to edit_vendor_vendor_insurance_path(@vendor,@vendor_insurance)
    end
  end

  def destroy
    vendor = Vendor.find(params[:vendor_id])
    vendor_insurance = VendorInsurance.find(params[:vendor_insurance_id])
    vendor_document = VendorDocument.find(params[:id])
    if vendor_document.destroy
      flash[:notice] = "Vendor Insurance Document deleted succesfully."
    else
      flash[:error] = "Error deleting Vendor Insurance Document - " + vendor_document.errors.full_messages.join(", ")
    end
    redirect_to edit_vendor_vendor_insurance_path(vendor,vendor_insurance)
  end

  def download
    @vendor_document = VendorDocument.find(params[:id])
    data = open(@vendor_document.document.to_s)
    send_data data.read,:type => "application/"+@vendor_document.document_content_type,:filename => @vendor_document.document_file_name
  end

  private

  def post_params
    params.require(:vendor_document).permit(:document)
  end
end
