class TokensController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorize_resource :show
  
  def show
    @token = Token.find_by_digest(params[:id])
    unless params[:status]
      if @token and !@token.expired?
        @event = @token.identity
        @event.expire_all_tokens
        @event.rate_event(@token)
        @event.update_attributes(:feedback_status => "reviewed")
        flash[:notice] = "Rating Submitted."
      elsif @token and @token.expired? 
        flash.clear
        @status = "expired"
        flash.now[:alert] = "Sorry, your review has already been submitted."
      else
        flash.clear
        @status = "not_found"
        flash.now[:alert] = "Token not found!"
      end
    else
      @status = "submitted"
    end
    render :layout => false 
  end
end
