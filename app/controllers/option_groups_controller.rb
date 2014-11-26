class OptionGroupsController < ApplicationController
  authorize_resource
  
  def toggle_favorite
    @option_group = OptionGroup.find params[:id]
    unless @option_group.evaluators_for(:favorite).include? current_user
      @option_group.add_or_update_evaluation(:favorite, 1, current_user)
      alert = "Added to Favorites."
    else
      @option_group.delete_evaluation(:favorite, current_user)
      alert = "Removed from Favorites."
    end
    render json: alert
  end

end
