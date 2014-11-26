class Admin::BuildingsController < ApplicationController
  respond_to :html
  authorize_resource

  def show
    @building = Building.find(params[:id])
    respond_to do |format|
      format.html
      format.js { render :json => {building: @building.html_address}}
    end
  end

  def edit
    @building = Building.find(params[:id])
  end

  def new
    @building = Building.new(address: Address.new)
  end

  def create
    @building = Building.new(permitted_params.building)

    if @building.save
      flash[:notice] = "Building created."

      if params[:referrer].nil? || params[:referrer].empty?
        redirect_to admin_root_path(:selected => "buildings")
      else
        redirect_to params[:referrer]
      end

    else
      flash[:error] = "Error creating Building  - " + @building.errors.full_messages.join(", ")
      redirect_to admin_root_path(:selected => "buildings")
    end
  end

  def update
    @building = Building.find(params[:id])
    if @building.update_attributes(permitted_params.building)
      flash[:notice] = "Building updated."
      redirect_to admin_root_path(:selected => "buildings")
    else
      flash[:error] = "Error updating Building  - " + @building.errors.full_messages.join(", ")
      redirect_to admin_root_path(:selected => "buildings")
    end
  end

  def destroy
    @building = Building.find(params[:id])
    begin
      @building.destroy
      flash[:notice] = "Building deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying Building - " + e.to_s
    end
    redirect_to admin_root_path(:selected => "buildings")
  end
end