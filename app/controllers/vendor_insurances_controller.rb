class VendorInsurancesController < ApplicationController
  authorize_resource
  
  def new
    @vendor = Vendor.find(params[:vendor_id])
    @vendor_insurance = VendorInsurance.new
  end

  def create
    @vendor = Vendor.find(params[:vendor_id])
    @vendor_insurance = VendorInsurance.new(post_params)
    @vendor_insurance.vendor_id = @vendor.id
    @vendor_insurance.user_id = current_user.id
    if @vendor_insurance.save
      @vendor_insurance.update_attribute(:building_id, params[:vendor_insurance][:building_id])
      flash[:notice] = "Vendor Insurance created succesfully."
      redirect_to edit_vendor_vendor_insurance_path(@vendor, @vendor_insurance)
    else
      flash[:error] = "Failed to create Vendor Insurance - " + @vendor_insurance.errors.full_messages.join(", ")
      redirect_to vendor_path(current_vendor, :selected => "insurances")
    end
  end

  def edit
    @vendor = Vendor.find(params[:vendor_id])
    @vendor_insurance = VendorInsurance.find(params[:id])
  end

  def update
    @vendor = Vendor.find(params[:vendor_id])
    @vendor_insurance = VendorInsurance.find(params[:id])
    @vendor_insurance.user_id = current_user.id
    if @vendor_insurance.update_attributes(post_params)
      flash[:notice] = "Vendor Insurance updated succesfully."
      redirect_to vendor_path(current_vendor, :selected => "insurances")
    else
      flash[:error] = "Failed to save Vendor Insurance - " + @vendor_insurance.errors.full_messages.join(", ")
      redirect_to vendor_path(current_vendor, :selected => "insurances")
    end
  end

  def destroy
    @vendor = Vendor.find(params[:vendor_id])
    @vendor_insurance = VendorInsurance.find(params[:id])
    @vendor_insurance.destroy
    flash[:notice] = "Vendor Insurance deleted succesfully."
    redirect_to vendor_path(current_vendor, :selected => "insurances")
  end

  private

  def post_params
    params.require(:vendor_insurance).permit(:building_id, :waiver_subrogation,:insurance_effective_date, :insurance_expiration_date)
  end

  protected

    def current_vendor
      @vendor ||= Vendor.find(params[:vendor_id])
    end
end
