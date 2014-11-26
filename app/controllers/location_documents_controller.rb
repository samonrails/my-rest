class LocationDocumentsController < ApplicationController
  authorize_resource
  def create
    location = Location.find(params[:location_id])
    @location_document = location.location_documents.new(permitted_params.location_document)
    @location_document.user_id = current_user.id
    if @location_document.save
      flash[:notice] = "Location Document created succesfully."
    else
      flash[:error] = "Error creating Location Document - " + @location_document.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def destroy
    location_document = LocationDocument.find(params[:id])
    location = location_document.location
    if location_document.destroy
      flash[:notice] = "Location Document deleted successfully."
    else
      flash[:error] = "Error deleting Location Document - " + location_document.errors.full_messages.join(", ")
    end
    redirect_to edit_account_location_path(location.account, location)
  end

  def download
    @location_document = LocationDocument.find(params[:id])
    data = open(@location_document.document.to_s)
    send_data data.read,:type => "application/"+@location_document.document_content_type,:filename => @location_document.document_file_name
  end

end
