class Select::SelectOrderItemsController < ApplicationController
  respond_to :html, :js

  def new_inventory_item
    @inventory_item = InventoryItem.find(params[:id])
    @select_order = Select::SelectOrder.find(params[:select_order_id])
    render "select/select_orders/new_inventory_item", layout: false
  end

  def create
    use_params = permitted_params.select_order_item
    use_params[:select_order_item_options_attributes] = extract_valid_options use_params[:select_order_item_options_attributes]
    @select_order_item = Select::SelectOrderItem.create(use_params)
    if @select_order_item.save
      flash[:notice] = "Select order item " + @select_order_item.inventory_item.name_public + " successfully added"
    else
      flash[:error] = "Error adding inventory item to select order - " + @select_order_item.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def update
    @select_order_item = Select::SelectOrderItem.find(params[:id])
    use_params = permitted_params.select_order_item
    use_params[:select_order_item_options_attributes] = extract_valid_options use_params[:select_order_item_options_attributes]
    # Remove all item options (they'll get re-created by this action)
    @select_order_item.select_order_item_options.destroy_all
    if @select_order_item.update_attributes(use_params)
      flash[:notice] = "Select order item " + @select_order_item.inventory_item.name_public + " updated successfully"
    else
      flash[:error] = "Error updating Select Order"
    end
    redirect_to :back
  end

  def destroy
    @select_order_item = Select::SelectOrderItem.find(params[:id])
    if @select_order_item.destroy
      flash[:notice] = "Select order item " + @select_order_item.inventory_item.name_public + " removed successfully"
    else
      flash[:error] = "Error removing inventory item from select order - " + @select_order_item.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  protected
  
    def extract_valid_options options
      valid_options = []
      if options
        options.each do |o|
          if o[:inventory_item_id] and o[:option_group_id]
            valid_options << o
          end
        end
      end
      valid_options
    end

end
