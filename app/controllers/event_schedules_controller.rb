class EventSchedulesController < ApplicationController
  authorize_resource
  respond_to :html

  def edit
    @account = account
    @event_schedule = EventSchedule.find(params[:id])
  end

  def new
    @account = account
  end

  def create
    # Fetch the current user
    params[:event_schedule][:created_by_id] = current_user.id unless current_user.nil?

    @event_schedule = EventSchedule.create(permitted_params.event_schedule)
    @event_schedule.account = account

    if @event_schedule.save
      flash[:notice] = "Schedule created."
      redirect_to account_path(account, :selected => "event_schedules")
    else
      flash[:error] = "Error creating schedule. - " + @event_schedule.errors.full_messages.join(", ")
      redirect_to new_account_event_schedule_path(account, @event_schedule)
    end
  end

  def update
    @event_schedule = EventSchedule.find(params[:id]) 

    if @event_schedule.update_attributes(permitted_params.event_schedule)
      flash[:notice] = "Event Schedule updated"
      redirect_to account_path(account, :selected => "event_schedules")
    else
      flash[:error] = "Error updating schedule - " + @event_schedule.errors.full_messages.join(", ")
      redirect_to edit_account_event_schedule_path(account, @event_schedule)
    end
  end

  def destroy
    @event_schedule = EventSchedule.find(params[:id])
    begin
      @event_schedule.destroy
      flash[:notice] = "Event Schedule destroyed"
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying Event Schedule - " + e.to_s
    end
    redirect_to account_path(account, :selected => "event_schedules")
  end

  protected

    def account
      @account = Account.find(params[:account_id])
    end

end