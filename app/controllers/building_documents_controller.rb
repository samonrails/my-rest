class BuildingDocumentsController < ApplicationController
  authorize_resource
  def create
    building = Building.find(params[:building_id])
    @building_document = building.building_documents.new(permitted_params.building_document)
    @building_document.user_id = current_user.id
    if @building_document.save
      flash[:notice] = "Building Document created succesfully."
    else
      flash[:error] = "Error creating Building Document - " + @building_document.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def destroy
    building_document = BuildingDocument.find(params[:id])
    building = building_document.building
    if building_document.destroy
      flash[:notice] = "Building Document deleted successfully."
    else
      flash[:error] = "Error deleting Building Document - " + building_document.errors.full_messages.join(", ")
    end
    redirect_to edit_admin_building_path(building)
  end

  def download
    @building_document = BuildingDocument.find(params[:id])
    data = open(@building_document.document.to_s)
    send_data data.read,:type => "application/"+@building_document.document_content_type,:filename => @building_document.document_file_name
  end

end
