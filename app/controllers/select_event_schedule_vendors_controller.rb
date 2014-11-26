class SelectEventScheduleVendorsController < ApplicationController
  authorize_resource
  respond_to :html
  
  def new
    @account = Account.find(params[:account_id])    
  end
    
  def show
    @account = Account.find(params[:account_id])
    @select_event_schedule_vendor = SelectEventScheduleVendor.find(params[:id])
    @select_event_schedule = SelectEventSchedule.find(@select_event_schedule_vendor.select_event_schedule_id)

    render :partial => "select_event_schedule_vendors/edit"
  end

  def create
    # This is so the javascript is not rewritten. The JS needs to be refactored so it will allow passed in id names. 
    # so we do not have to force feed as such (same JS for various pages touching different models)
    params[:select_event_schedule_vendor][:menu_template_id ] ||= params[:event_vendor][:menu_template ]
    params[:select_event_schedule_vendor][:vendor_id ] ||= params[:select_event_schedule_vendor][:vendor ]
    
    @select_event_schedule_vendor = SelectEventScheduleVendor.new(permitted_params.select_event_schedule_vendor)
    
    if @select_event_schedule_vendor.save
      flash[:notice] = "Select Event Schedule Vendor added."
      redirect_to :back
    else
      flash[:error] = "Error creating select event schedule. - " + @select_event_schedule.errors.full_messages.join(", ")
      redirect_to account_path(account, :selected => "select_event_schedules")
    end
    
  end

  def update
    # This is so the javascript is not rewritten. The JS needs to be refactored so it will allow passed in id names. 
    # so we do not have to force feed as such (same JS for various pages touching different models)
    params[:select_event_schedule_vendor][:menu_template_id ] ||= params[:event_vendor][:menu_template ]
    params[:select_event_schedule_vendor][:vendor_id ] ||= params[:select_event_schedule_vendor][:vendor ]
    
    @select_event_schedule_vendor = SelectEventScheduleVendor.find(params[:id]) 
    if @select_event_schedule_vendor.update_attributes(permitted_params.select_event_schedule_vendor)
      flash[:notice] = "Select Event Schedule Vendor updated"
      redirect_to :back
    else
      flash[:error] = "Error updating vendor - " + @select_event_schedule_vendor.errors.full_messages.join(", ")
      redirect_to :back
    end  
  end
  
  def destroy
    @select_event_schedule_vendor = SelectEventScheduleVendor.find(params[:id])
    begin
      @select_event_schedule_vendor.destroy
      flash[:notice] = "Select Event Vendor deleted."
      redirect_to :back
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying select event vendor - " + e.to_s
      redirect_to :back
    end
  end
end
