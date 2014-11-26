class GlobalSettingsController < ApplicationController
  authorize_resource
  def create
    if params[:global_setting] && params[:global_setting].kind_of?(Hash)
      params[:global_setting].each do |k,v|
      GlobalSetting[k] = v.to_f
      end
    end
    flash[:notice] = "Settings Saved Successfully"
    redirect_to admin_root_path(selected: "event_reviews")
  end
end
