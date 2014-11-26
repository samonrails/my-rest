class MenuLevelDiscountsController < ApplicationController
  authorize_resource
  respond_to :html

  def new
    respond_with @menu_level_discount = MenuLevelDiscount.new(:event_vendor_id => params[:event_vendor_id])
  end

  def edit
    respond_with @menu_level_discount = MenuLevelDiscount.find(params[:id])
  end

  def create
    @menu_level_discount  = current_event_vendor.menu_level_discounts.create(permitted_params.menu_level_discount)
    current_event.set_menu_level_discount_sell_price(@menu_level_discount)

    if @menu_level_discount.save
      flash[:notice] = "Menu Level Discount created successfully."
      redirect_to edit_event_event_vendor_path(current_event, current_event_vendor)
    else
      flash[:notice] = "Error creating Menu Level Discount."
      redirect_to edit_event_event_vendor_path(current_event, current_event_vendor)
    end
  end

  def update
    @menu_level_discount = MenuLevelDiscount.find(params[:id])

    if @menu_level_discount.update_attributes!(permitted_params.menu_level_discount)
      flash[:notice] = "Menu updated successfully."
      redirect_to edit_event_event_vendor_path(current_event, current_event_vendor)
    else
      flash[:notice] = "Error updating Menu Level Discount."
      redirect_to edit_event_event_vendor_path(current_event, current_event_vendor)
    end
  end

  def destroy
    @menu_level_discount = MenuLevelDiscount.find(params[:id])
    @event_vendor = EventVendor.find(@menu_level_discount.event_vendor_id)
    @event = Event.find(@event_vendor.event_id)

    if @menu_level_discount.destroy
      flash[:notice] = "Menu Level Discount destroyed."
      redirect_to edit_event_event_vendor_path(current_event, current_event_vendor)
    else
      flash[:notice] = "Error deleting Menu Level Discount."
      redirect_to edit_event_event_vendor_path(current_event, current_event_vendor)
    end
  end

  protected

    def current_event_vendor
      @event_vendor ||= EventVendor.find(params[:menu_level_discount][:event_vendor_id])
    end

    def current_event
      @event ||= Event.find(current_event_vendor.event_id)
    end

end