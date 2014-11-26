class IssuesController < ApplicationController
  authorize_resource

  def index
    @open_issues = current_user.opened_assigned_issues
    @closed_issues = current_user.closed_assigned_issues
    respond_to do |format|
      format.html
      format.json {render json: {open_issues: @open_issues, closed_issues: @closed_issues}}
    end
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def create
    @issue = current_subject.issues.new(permitted_params.issue)

    if @issue.save
      flash[:notice] = "Issue created."
      redirect_to current_subject_path
    else
      flash[:error] = "Error creating issue - " + @issue.errors.full_messages.join(", ")
      redirect_to current_subject_path
    end
  end

  def update
    @issue = Issue.find(params[:id])
    if @issue.update_attributes(permitted_params.issue)
      flash[:notice] = "Changes made succesfully."
      redirect_to current_subject ? current_subject_path : root_path
    else
      flash[:error] = "Error updating issue - " + @issue.errors.full_messages.join(", ")
      redirect_to current_subject ? current_subject_path : root_path
    end
  end

  def toggle
    @issue = Issue.find(params[:id])

    new_status = !@issue.status
    new_status_message = new_status ? "Closed" : "Reopened"

    if @issue.update_attributes(status: new_status)
      flash[:notice] = "Issue #{new_status_message} succesfully."
      redirect_to @issue
    else
      flash[:error] = "Error updating issue"
      redirect_to @issue
    end
  end

  protected

    def current_subject
      @subject = params[:subject_type].constantize.find(params[:subject_id]) if params[:subject_type]
    end

    def current_subject_path
      path_name = send("#{@subject.class.name.underscore}_path".to_sym, current_subject, :selected => "issues")
    end

end
