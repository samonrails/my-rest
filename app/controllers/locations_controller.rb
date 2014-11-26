class LocationsController < ApplicationController
  authorize_resource
  respond_to :html, :json

  def show
    respond_to do |format|

      format.html do
        respond_with(@location = Location.find(params[:id]), @account = current_account)
      end

      format.json do
        respond_with(@location = Location.find(params[:id]))
      end
    end
  end

  def edit
    @location = current_account.locations.with_deleted.find(params[:id])
  end

  def new
    respond_with(@location = current_account.locations.build)
  end

  def create
    params[:location][:created_by_id] = current_user.id unless current_user.nil?
    params[:location][:name] = params[:location][:building_address_notes]
    @location = locations.new(permitted_params.location)

    if @location.save
      flash[:notice] = "Location created."
      redirect_to account_path(current_account, :selected => "locations")
    else
      flash[:error] = "Error creating Location - " + @location.errors.full_messages.join(", ")
      redirect_to account_path(current_account, :selected => "locations")
    end
  end

  def update
    @location = current_account.locations.find(params[:id])
    params[:location][:name] = params[:location][:building_address_notes]
    if @location.update_attributes(permitted_params.location)
      flash[:notice] = "Location updated."
      redirect_to account_path(current_account, :selected => "locations")
    else
      flash[:error] = "Error updating Location - " + @location.errors.full_messages.join(", ")
      redirect_to account_path(current_account, :selected => "locations")
    end
  end

  def destroy
    @location = current_account.locations.find(params[:id])
    begin
      @location.destroy
      flash[:notice] = "Location deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error deleting location - " + e.to_s
    end
    redirect_to account_path(current_account, :selected => "locations")
  end

  def restore
    @location = Location.with_deleted.find(params[:id])
    @location.deleted_at = nil
    if @location.save
      flash[:notice] = "Location restored."
    else
      flash[:error] = "Error restoring location."
    end
    redirect_to account_path(current_account, :selected => "locations")
  end

  protected

    def locations
      @locations ||= current_account.locations
    end

    def current_account
      @account ||= Account.find(params[:account_id])
    end

end