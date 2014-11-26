class SelectEventsController < ApplicationController
  authorize_resource


  def index
    @select_events = SelectEvent.all
    respond_with(@select_events)
  end

  def show
    @select_event = SelectEvent.find(params[:id])
    @select_orders = Kaminari.paginate_array(@select_event.select_orders.all).page(params[:page])
    respond_to do |format|
      format.html
    end
  end

  def new
    @select_event = SelectEvent.new
  end

  def edit
    @select_event = SelectEvent.find(params[:id])
  end

  def create
    # Fetch the current user
    params[:select_event][:created_by_id] = current_user.id unless current_user.nil?

    @select_event = SelectEvent.create(permitted_params.select_event)

    if @select_event.save
      flash[:notice] = "Select Event created successfully."
      redirect_to @select_event
    else
      flash[:error] = "Error creating Select Event - " + @select_event.errors.full_messages.join(", ")
      redirect_to events_url
    end
  end

  def update
    @select_event = SelectEvent.find(params[:id])

    if @select_event.update_attributes(permitted_params.select_event)
      flash[:notice] = "Select Event updated successfully."
      redirect_to @select_event
    else
      flash[:error] = "Error updating Select Event - " + @select_event.errors.full_messages.join(", ")
      redirect_to @select_event
    end
  end

  def destroy
    @select_event = SelectEvent.find(params[:id])
    begin
      @select_event.destroy
      flash[:notice] = "Select Event deleted."
      redirect_to select_events_url
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying select event - " + e.to_s
      render action: "show"
    end
  end

  def update_campaign
    @select_event = SelectEvent.find(params[:select_event_id])

    error_msg = ''

    begin
      @select_event.update_attributes!(permitted_params.select_event)

      # Mailchimp takes dates in UTC time zone.
      campaign_options = {:formatted_introduction_email_time => @select_event.introduction_email_time_utc.to_s(:mailchimp_datetime_format),
                          :formatted_final_email_time => @select_event.final_email_time_utc.to_s(:mailchimp_datetime_format),
                         }

      if current_user.id.present?
        campaign_options[:campaign_created_by_id] = current_user.id
      end

      # Create the campaigns with pending status
      campaign_ids = @select_event.create_pending_campaigns campaign_options[:campaign_created_by_id], params
      campaign_options[:campaign_id] = campaign_ids

      # To Sidekiq we go to create and schedule the campaign
      @select_event.schedule_email_campaigns campaign_options

      error_msg = "Select Event updated and Email Campaigns created successfully."
    rescue RuntimeError
      error_msg = "Error updating Select Event - " + @select_event.errors.full_messages.join(", ")
    end

    render :json => { :message => error_msg }
  end

  def campaign_table
    @select_event = SelectEvent.find(params[:select_event_id])

    render partial: "select_events/notifications_table"
  end



end
