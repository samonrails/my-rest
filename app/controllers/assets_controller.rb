class AssetsController < ApplicationController
  authorize_resource
  respond_to :html, :json, :js

  def index
    @enclosing_resource = enclosing_resource
    respond_with @assets = @enclosing_resource.assets
  end

  def create
    @asset = enclosing_resource.assets.new permitted_params.asset
    @asset.save
  end

  def set_default
    @asset = Asset.find params[:id]
    owner = @asset.owner

    if @asset.update_attributes(permitted_params.asset)
      owner.assets.each {|a| a.update_attribute(:is_default, false) unless a.id == @asset.id}
      flash[:notice] = "Asset Updated created."
    else
      flash[:error] = "Error updating asset - " + @asset.errors.full_messages.join(", ")
    end
    respond_with @asset
  end

  def destroy
    @asset = Asset.find params[:id]
    @asset.destroy
    flash[:notice] = "Image deleted."
    respond_with @asset
  end

  private

    def enclosing_resource
      if params[:inventory_item_id]
        InventoryItem.find params[:inventory_item_id]
      elsif params[:location_id]
        Location.find params[:location_id]
      elsif params[:building_id]
        Building.find params[:building_id]
      elsif params[:vendor_id]
        Vendor.find params[:vendor_id]
      elsif params[:menu_template_id]
        MenuTemplate.find params[:menu_template_id]
      end
    end

end
