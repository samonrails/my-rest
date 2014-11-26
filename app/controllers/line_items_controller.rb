class LineItemsController < ApplicationController
  authorize_resource
  respond_to :html

  def index
    respond_with(@line_items = current_event.line_items)
  end

  def show
    respond_with(@line_item = LineItem.find(params[:id]), @event = current_event)
  end

  def new
    @line_item = LineItem.new(
        :payable_party_type => params[:payable_party_type],
        :payable_party_id => params[:payable_party_id],
        :include_price_in_expense => true, 
        :billable_party_type => params[:billable_party_type],
        :billable_party_id => params[:billable_party_id],
        :include_price_in_revenue => true,
        :quantity => 1)
  
    respond_with(@line_item, @event = current_event)
  end

  def new_menu_item
    @vendor = Vendor.find(params[:vendor])
    @line_item = LineItem.new(:line_item_type => "Goods", :line_item_sub_type => "Menu-Item", :quantity => 0, :payable_party_id => @vendor.id)

    respond_with(@vendor, @line_item, @event = current_event)
  end

  def edit
    @line_item = current_event.line_items.find(params[:id])
  end

  def create

    if (!params[:line_item][:inventory_item_id].nil?)
      # Line item from Inventory Item
      current_event.create_line_item_from_inventory_item_id(
        params[:line_item][:inventory_item_id], 
        params[:line_item][:quantity], 
        params[:line_item][:include_price_in_expense], 
        params[:line_item][:include_price_in_revenue],
        params[:line_item][:notes])
    else
      @line_item_type = LineItemType.find(params[:line_item_type_id])

      if (@line_item_type.line_item_sub_type == "Menu-Fee")
        # Line item from per-person fee
        current_event.create_line_item_for_per_person_charge(
          params[:line_item][:quantity], 
          params[:line_item][:payable_party_id], 
          params[:line_item][:notes])
      else
        # Non-menu line item
        
        if params[:line_item][:name] == ""
          params[:line_item][:name] = @line_item_type.line_item_sub_type
        end

        current_event.line_items.create!(
          permitted_params.line_item.merge({
            :line_item_type => @line_item_type.line_item_type, 
            :line_item_sub_type => @line_item_type.line_item_sub_type,
            :sku => @line_item_type.sku}))
      end
    end

    current_event.trigger_event_rollup

    flash[:notice] = "Line item created successfully."
    redirect_to_tab_based_on_commit
  end


  def update
    @line_item = current_event.line_items.find(params[:id])

    if @line_item.update_attributes(permitted_params.line_item)
      @line_item.process_add_ons(params[:inventory_item_quantity]) if params[:inventory_item_quantity]
      current_event.trigger_event_rollup
      flash[:notice] = "Line Item updated."
    else
      flash[:error] = "Error updating Line Item."
    end

    redirect_to_tab_based_on_commit
  end

  def destroy
    @line_item = LineItem.find(params[:id])

    if @line_item.event.destroy_line_items [@line_item]    
      # Destroy add-ons
      @line_item.add_ons.destroy(@line_item.add_ons.all)

      # If menu-item, destroy the opposing line item
      if params[:menu_item]
        @line_item.delete_opposing_line_item
      end

      current_event.trigger_event_rollup
      flash[:notice] = "Line Item destroyed."
      redirect_to current_event
    else
      render action: "show"
    end
  end

  protected

    def current_event
      @event ||= Event.find(params[:event_id])
    end

    def redirect_to_tab_based_on_commit
      if params[:commit].downcase.include? "menu"
        redirect_to event_path(current_event, :selected => "menu")
      else
        redirect_to event_path(current_event, :selected => "financials")
      end
    end

end