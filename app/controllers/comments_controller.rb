class CommentsController < ApplicationController
  authorize_resource
  
  def create
    issue = Issue.find(params[:issue_id])
    @comment = issue.comments.new(permitted_params.comment)

    if @comment.save
      flash[:notice] = "Comment created."
    else
      flash[:error] = "Error creating comment - " + @comment.errors.full_messages.join(", ")
    end
    redirect_to issue
  end

end
