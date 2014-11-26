class CapacitiesController < ApplicationController
  authorize_resource
  def create
    vendor = Vendor.find(params[:vendor_id])
    @capacity = vendor.capacities.new(permitted_params.capacity)
    if @capacity.save
      flash[:notice] = "Capacity created."
    else
      flash[:error] = "Error creating Capacity."
    end
    redirect_to send("vendor_path".to_sym, vendor, :selected => "capacity")
  end

  def update
    vendor = Vendor.find(params[:vendor_id])
    @capacity = Capacity.find(params[:id])
    if @capacity.update_attributes(permitted_params.capacity)
      flash[:notice] = "Changes made successfully!"
    else
      flash[:error] = "Error updating capacity - " + @capacity.errors.full_messages.join(", ")
    end
    redirect_to send("vendor_path".to_sym, vendor, :selected => "capacity")
  end

end
