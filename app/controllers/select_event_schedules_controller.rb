class SelectEventSchedulesController < ApplicationController
  authorize_resource
  respond_to :html

  def new
    @account = Account.find(params[:account_id])    
  end

  def edit
    @account = Account.find(params[:account_id])
    @select_event_schedule = SelectEventSchedule.find(params[:id])
  end

  def create
    params[:select_event_schedule][:created_by_id] = current_user.try(:id)

    @select_event_schedule = SelectEventSchedule.create(permitted_params.select_event_schedule)

    if @select_event_schedule.save
      flash[:notice] = "Select Event Schedule created."
      account = @select_event_schedule.account 
      redirect_to account_path(account, :selected => "event_schedules")
    else
      flash[:error] = "Error creating select event schedule. - " + @select_event_schedule.errors.full_messages.join(", ")
      redirect_to new_account_select_event_schedule_path(@select_event_schedule.account, @select_event_schedule)
    end
  end

  def update
    @select_event_schedule = SelectEventSchedule.find(params[:id]) 
    if @select_event_schedule.update_attributes(permitted_params.select_event_schedule)
      flash[:notice] = "Select Event Schedule updated"
      redirect_to account_path(@select_event_schedule.account, :selected => "select_event_schedules")
    else
      flash[:error] = "Error updating schedule - " + @select_event_schedule.errors.full_messages.join(", ")
      redirect_to edit_account_select_event_schedule_path(@select_event_schedule.account, @select_event_schedule)
    end
  end

  def destroy
    @select_event_schedule = SelectEventSchedule.find(params[:id])
    begin
      @select_event_schedule.destroy
      flash[:notice] = "Select Event Schedule destroyed"
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying Select Event Schedule - " + e.to_s
    end
    redirect_to account_path(@select_event_schedule.account, :selected => "event_schedules")
  end
end
