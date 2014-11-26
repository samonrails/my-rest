class SelectEventVendorsController < ApplicationController
  authorize_resource
  respond_to :html
  
  def new
    @select_event = SelectEvent.find(params[:select_event_id])
    @select_event_vendor = SelectEventVendor.new
    render :partial => "select_event_vendors/new"
  end
  
  def show
    @select_event = SelectEvent.find(params[:select_event_id])
    @select_event_vendor = SelectEventVendor.find(params[:id])
    render :partial => "select_event_vendors/edit"
  end
  
  def create
    # This is so the javascript is not rewritten. The JS needs to be refactored so it will allow passed in id names. 
    # so we do not have to force feed as such (same JS for various pages touching different models)
    params[:select_event_vendor][:menu_template_id ] ||= params[:event_vendor][:menu_template ]
    params[:select_event_vendor][:vendor_id ] ||= params[:select_event_vendor][:vendor ]
    
    @select_event_vendor = SelectEventVendor.new(permitted_params.select_event_vendor)
    
    if @select_event_vendor.save
      flash[:notice] = "Select Event Vendor added."
      redirect_to :back
    else
      flash[:error] = "Error creating select event. - " + @select_event_vendor.errors.full_messages.join(", ")
      redirect_to :back
    end
    
  end
  
  def update
    # This is so the javascript is not rewritten. The JS needs to be refactored so it will allow passed in id names. 
    # so we do not have to force feed as such (same JS for various pages touching different models)

    params[:select_event_vendor][:menu_template_id ] ||= params[:event_vendor][:menu_template ]
    params[:select_event_vendor][:vendor_id ] ||= params[:select_event_vendor][:vendor ]
    
    @select_event_vendor = SelectEventVendor.find(params[:id]) 
    if @select_event_vendor.update_attributes(permitted_params.select_event_vendor)
      flash[:notice] = "Select Event Vendor updated"
      redirect_to :back
    else
      flash[:error] = "Error updating vendor - " + @select_event_vendor.errors.full_messages.join(", ")
      redirect_to :back
    end  
  end


  def destroy
    @select_event_vendor = SelectEventVendor.find(params[:id])
    begin
      @select_event_vendor.destroy
      flash[:notice] = "Select Event Vendor deleted."
      redirect_to :back
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying select event vendor - " + e.to_s
      redirect_to :back
    end
  end
end
