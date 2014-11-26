class EventVendorsController < ApplicationController
  authorize_resource
  respond_to :html

  def new
    respond_with @event = current_event, @event_vendor = EventVendor.new(:event_id => params[:event_id]), @menu_template = MenuTemplate.new()
  end

  def edit
    @event = current_event
    @event_vendor = EventVendor.find(params[:id])
    @menu_templates = @event_vendor.vendor.menu_templates_by_product(current_event.product)
    respond_with @event, @event_vendor, @menu_templates
  end

  def create
    if params[:event_vendor][:menu_template]
      participation = (params[:event_vendor][:participation].to_i.to_s == params[:event_vendor][:participation]) ? params[:event_vendor][:participation] : current_event.quantity
      current_event.add_replace_menu_template(params[:event_vendor][:menu_template], participation)
      current_event.update_status_after_manual_save

      flash[:notice] = "Vendor successfully added to event."
      redirect_to edit_event_event_vendor_path(current_event, current_event.event_vendors.last)
    else
      flash[:error] = "Error: No Menu Template chosen."
      redirect_to current_event
    end
  end

  def update
    @event_vendor = current_event.event_vendors.find(params[:id])

    # Safeties
    if (@event_vendor.invoiced_line_items? && @event_vendor.menu_template_id.to_s != params[:event_vendor][:menu_template_id])
      flash[:error] = "Not allowed to change menu template for vendor with invoiced line items."
      redirect_to current_event
    else
      current_event.add_replace_menu_template(params[:event_vendor][:menu_template_id], params[:event_vendor][:participation])
      current_event.update_status_after_manual_save

      flash[:notice] = "Vendor information updated successfully."
      redirect_to current_event
    end
  end

  def destroy
    @event_vendor = EventVendor.find(params[:id])

    # Safeties
    if (@event_vendor.invoiced_line_items? && @event_vendor.menu_template_id != params[:event_vendor][:menu_template_id])
      flash[:error] = "Not allowed to delete menu template for vendor with invoiced line items."
      redirect_to current_event
    else
      current_event.remove_info_for_vendor(@event_vendor.vendor_id)
      current_event.update_status_after_manual_save
      flash[:notice] = "Vendor removed from event."
      redirect_to current_event
    end
  end

  def change_grouped_menu_template_selections
    @event_vendor = EventVendor.find(params[:id])

    # Safeties
    if (@event_vendor.invoiced_line_items?)
      flash[:error] = "Not allowed to change menu template selections for vendor with invoiced line items."
      redirect_to current_event
    else
      if params[:item_ids]
        if @event_vendor.menu_template.are_selections_valid(params[:item_ids])
          current_event.change_inventory_items_for_event_vendor(@event_vendor.vendor_id, params[:item_ids], params[:include_expense_price] || [], params[:include_revenue_price] || [], [])
          current_event.update_status_after_manual_save
          flash[:notice] = "Menu Items Updated"
          redirect_to current_event
        else
          flash[:error] = "Menu Items NOT Updated.  Check selections."
          redirect_to edit_event_event_vendor_path(current_event, @event_vendor)
        end
      else
        current_event.change_inventory_items_with_quantities_for_event_vendor(@event_vendor.vendor_id, params[:inventory_item_quantity], params[:include_expense_price] || [], params[:include_revenue_price] || [])
        current_event.update_status_after_manual_save
        flash[:notice] = "Menu Items Updated"
        redirect_to current_event
      end
      
    end

  end

  protected

    def current_event
      @event ||= Event.find(params[:event_id])
    end

end