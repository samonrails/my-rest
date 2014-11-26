class Admin::DeliveryGroupsController < ApplicationController

  layout "modal"
  respond_to :js
  before_filter :delivery_group

  authorize_resource

  def new
  end

  def create
    delivery_group = current_user.delivery_groups.new(delivery_group_params)
    delivery_group.save ? notice("created") : error
    head :ok
  end

  def edit
  end

  def update
    delivery_group.update_attributes(delivery_group_params) ? notice("updated") : error
    head :ok
  end

  def destroy
    delivery_group.destroy
    notice("deleted")
    redirect_to :back
  end

  private

  def notice(crud)
    flash[:notice] = "Delivery Group #{crud}."
  end

  def error
    delivery_group.valid? # Force validation check for errors
    flash[:error] = "Error with Delivery Group - " + delivery_group.errors.full_messages.join(", ")
  end

  def delivery_group
    @delivery_group ||= if params[:id].present?
      current_user.delivery_groups.find(params[:id])
    else
      current_user.delivery_groups.build
    end
  end

  def delivery_group_params
    params.require(:delivery_group).permit(:name, location_ids: [])
  end
end
