class VendorPreferencesController < ApplicationController
  authorize_resource
  respond_to :html

  def show
    respond_with(@preference = Preference.find(params[:id]), @vendor = current_vendor)
  end

  def edit
    @preference = current_vendor.vendor_preferences.find(params[:id])
  end

  def new
    respond_with(@preference = current_vendor.vendor_preferences.build)
  end

  def create
    @preference = preferences.create(permitted_params.vendor_preference)

    if @preference.save
      flash[:notice] = "Preference created."
      redirect_to vendor_path(current_vendor, :selected => "preferences")
    else
      flash[:error] = "Error creating Preference - " + @preference.errors.full_messages.join(", ")
      redirect_to vendor_path(current_vendor, :selected => "preferences")
    end
  end

  def update
    @preference = current_vendor.vendor_preferences.find(params[:id])
    if @preference.update_attributes(permitted_params.vendor_preference)
      flash[:notice] = "Preference updated."
      redirect_to vendor_path(current_vendor, :selected => "preferences")
    else
      flash[:error] = "Error updating Preference - " + @preference.errors.full_messages.join(", ")
      redirect_to vendor_path(current_vendor, :selected => "preferences")
    end
  end

  def destroy
    @preference = preferences.find(params[:id])
    begin
      @preference.destroy
      flash[:notice] = "Preference deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying preference - " + e.to_s
    end
    redirect_to vendor_path(current_vendor, :selected => "preferences")
  end

  protected

    def preferences
      @preferences ||= current_vendor.vendor_preferences
    end

    def current_vendor
      @vendor ||= Vendor.find(params[:vendor_id])
    end

end