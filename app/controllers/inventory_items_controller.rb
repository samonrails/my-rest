class InventoryItemsController < ApplicationController
  authorize_resource
  respond_to :html

  def edit
    respond_with(
      @inventory_item = current_vendor.inventory_items.find(params[:id]),
      @inventory_items_options = InventoryItem.where(vendor_id: current_vendor.id, inventory_item_option: true))
  end

  def create
    @inventory_item = inventory_items.create(permitted_params.inventory_item)
    @inventory_item.remove_option_groups if params[:inventory_item][:inventory_item_option]

    if @inventory_item.save
      flash[:notice] = "Inventory item created."
      redirect_to edit_vendor_inventory_item_path(current_vendor, @inventory_item)
    else
      flash[:error] = "Error creating inventory item. - " + @inventory_item.errors.full_messages.join(", ")
      redirect_to vendor_path(current_vendor, :selected => "inventory_items") 
    end
  end

  def update
    @inventory_item = current_vendor.inventory_items.find(params[:id])

    @inventory_item.product_types_allowed = {}

    if @inventory_item.update_attributes(permitted_params.inventory_item)
      @inventory_item.remove_option_groups if @inventory_item.inventory_item_option
      flash[:notice] = "Inventory item updated."
    else
      flash[:error] = "Error updating inventory item."
    end
    redirect_to vendor_path(current_vendor, :selected => "inventory_items", :new_inventory_item => params[:submit] == "Save & Add Another")
  end

  def destroy

    @inventory_item = current_vendor.inventory_items.find(params[:id])
    begin
      @inventory_item.destroy
      flash[:notice] = "Inventory item deleted."
      redirect_to vendor_path(current_vendor, :selected => "inventory_items")
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error deleting inventory item - " + e.to_s
      redirect_to vendor_path(current_vendor, :selected => "inventory_items")
    end

  end

  # custom handlers
  # -----------------------------------

  def create_option_group
    @inventory_item = InventoryItem.find(params[:id])
    @option_group = @inventory_item.option_groups.new(:name => params[:name], :included => params[:included], :max => params[:max], :required => params[:required])

    if @option_group.save
      # Next, update the inventory items associated with this group
      @inventory_item.update_option_group_inventory_items(@option_group, params[:item_ids])
      flash[:notice] = "Inventory Item Option Group added successfully"
      redirect_to edit_vendor_inventory_item_path(current_vendor, @inventory_item)
    else
      flash[:error] = "Error adding Inventory Item Option Group - " + @option_group.errors.full_messages.join(", ")
      redirect_to edit_vendor_inventory_item_path(current_vendor, @inventory_item)
    end
  end

  def update_option_group
    @inventory_item = InventoryItem.find(params[:id])
    @option_group = params[:option_group_id] == "" ? nil : OptionGroup.find(params[:option_group_id])

    # First, update the attributes
    @option_group.update_attributes!(:name => params[:name], :included => params[:included], :max => params[:max], :required => params[:required]) unless @option_group.nil?

    # Next, update the inventory items associated with this group
    @inventory_item.update_option_group_inventory_items(@option_group, params[:item_ids])

    redirect_to edit_vendor_inventory_item_path(current_vendor, @inventory_item)
  end

  def delete_option_group
    @inventory_item = InventoryItem.find(params[:id])
    @inventory_item.option_groups.find(params[:option_group_id]).destroy
    
    flash[:notice] = "Inventory Item option group deleted successfully"
    redirect_to edit_vendor_inventory_item_path(current_vendor, @inventory_item)
  end


  protected

    def inventory_items
      @inventory_items ||= current_vendor.inventory_items
    end

    def current_vendor
      @vendor ||= Vendor.find(params[:vendor_id])
    end
end