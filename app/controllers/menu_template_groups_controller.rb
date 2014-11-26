class MenuTemplateGroupsController < ApplicationController
  authorize_resource
  
  def toggle_favorite
    @menu_template_group = MenuTemplateGroup.find params[:id]
    unless @menu_template_group.evaluators_for(:favorite).include? current_user
      @menu_template_group.add_or_update_evaluation(:favorite, 1, current_user)
       alert = "Added to Favorites."
    else
      @menu_template_group.delete_evaluation(:favorite, current_user)
       alert = "Removed from Favorites."
     end
    render json: alert
  end
end
