class EventsController < ApplicationController
  authorize_resource :except => [:update_reviews]
  before_filter :authenticate_user!, :except => [:update_reviews]
  respond_to :html, :js

  def index
    options = {:artificial_attributes => {"vendor"=>"vendors.name","account"=>"accounts.name", "event_time" => "event_start_time", "date" => "event_start_time", "market" => "markets.name", "account_executive" => "users.email"}}
    respond_to do |format|
      format.html do
        if params[:xls]
          redirect_to :action => "index", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          begin
            @events = Event.search "*", index_name: Search.indexes_to_search, query: Search.where_clauses_es( params ), order: Search.order_options( params ), include: [[:account => :account_exec], :vendors, [:location => [:building => :market]] ], page: params[:page], per_page: 15
          rescue
            flash[:error] = "Could not retrieve events from ElasticSearch - showing the last 10 events."
            @events = Kaminari.paginate_array(Event.last(5) + SelectEvent.last(5)).page(params[:page])
          end
        end
      end
      format.xls do
        begin
          @events = Event.search "*", index_name: Search.indexes_to_search, query: Search.where_clauses_es( params ), order: Search.order_options( params ), include: [[:account => :account_exec], :vendors, [:location => [:building => :market]] ]
        rescue
          @events = Event.last(5) + SelectEvent.last(5)
        end
        headers["Content-Disposition"] = "attachment; filename=\"my_events.xls\""
      end
    end
  end

  def show
    @event = Event.find(params[:id])
    @documents = @event.documents.all
    @user = params[:selected_user] ? User.find(params[:selected_user]) : @event.order.try(:user)

    respond_to do |format|
      format.html
    end
  end

  def new
      @event = Event.new
      @products = Product.available_values
  end

  def edit
    respond_with @event = Event.find(params[:id])
  end


  def create
    params[:event][:created_by_id] = current_user.id unless current_user.nil?
    @event = Event.new(permitted_params.event)

    if @event.save
      @event.trigger_event_rollup      
      @event.update_transaction_method
      flash[:notice] = "Event created successfully."
      redirect_to @event
    else
      flash[:error] = "Error creating event - " + @event.errors.full_messages.join(", ")
      redirect_to events_url
    end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(permitted_params.event)
      @event.update_status_after_manual_save
      flash[:notice] = "Event updated successfully."
      redirect_to @event
    else
      flash[:error] = "Error updating event - " + @event.errors.full_messages.join(", ")
      redirect_to @event
    end
  end

  def destroy
    @event = Event.find(params[:id])
    begin
      @event.destroy
      flash[:notice] = "Event deleted."
      redirect_to events_url
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying event - " + e.to_s
      render action: "show"
    end
  end

  # -- Custom Methods -- #
  # This method grabs the party (party_id), party_type (account/vendor)
  # that is being passed up from the view layer, and then delegates the
  # objects @party and @event to the model method.
  def generate
    @event = Event.find(params[:id])
    %w{action controller}.each {|key| params.delete(key)}
    params[:current_user] = current_user.id
    document = @event.generate_document(params)

    document ? flash[:notice] = "#{params[:doc_type].titleize} being generated. Please refresh the document table in a few seconds." : flash[:alert] = "Failed to generate #{params[:doc_type].titleize}."
    redirect_to event_path(selected: 'financials')
  end

  # Reset the building and location site notes to the parent notes from the 
  # current location.
  def reload_site_notes
    @event = Event.find(params[:id])
    @event.reload_site_notes
    @event.save

    flash[:notice] = "Reset Location and Building notes."
    redirect_to event_path(selected: 'notes')
  end

  def update_transaction_method
    @event = Event.find(params[:id])
    case params[:party_type]
      when "Account"
        if params[:transaction_method]
          @event.event_transaction_method.update_attributes!(:transaction_method => params[:transaction_method], :info1 => params[:info1], :info2 => params[:info2])
          respond_with(@event, @party = @event.account, @event_transaction_method = @event.event_transaction_method)
        else
          if params[:card_token]
            begin
              bt_card = Braintree::CreditCard.find params[:card_token]
               @event.event_transaction_method.update_attributes({:transaction_method => params[:event][:transaction_method], 
                                :info1 => bt_card.try(:cardholder_name),
                                :info2 => bt_card.try(:last_4),
                                :transaction_card_token => params[:card_token] })
            rescue => e
              Rails.logger.error "Could not find braintree credit card token: #{params[:card_token]} for event #{@event.id}"
            end
          else
             @event.event_transaction_method.update_attributes(:transaction_method => params[:event][:transaction_method])
          end
        end
      when "Vendor"
        @event.event_vendors.where(:vendor_id => params[:party_id]).first.event_transaction_method.update_attributes!(:transaction_method => params[:transaction_method], :info1 => params[:info1], :info2 => params[:info2])
        respond_with(@event, @party = @event.event_vendors.where(:vendor_id => params[:party_id]).first.vendor, @event_transaction_method = @event.event_vendors.where(:vendor_id => params[:party_id]).first.event_transaction_method)
      else
        respond_with(@event)
      end
  end

  def duplicate_event
    @event = Event.find(params[:id])
    if(params[:event_start_time] != '')
      @event = @event.duplicate current_user.id, params
      if @event.valid?
        respond_with @event
      else
        respond_with(@error = "Error duplicating event - " + @event.errors.full_messages.join(", "))
      end
    else
      respond_with(@error = "Event start date required")
    end
  end

  def send_feedback_email
    event = Event.find(params[:event_id])
    event.create_active_tokens
    if event.contact and Notifier.send_feedback_email(event).deliver
      event.update_attributes(:feedback_status => "sent")
      event.touch :feedback_updated_at
      flash[:notice] = "Feedback Email Sent Successfully."
    else
      flash[:notice] = "Error occured in sending feedback email."
    end
    redirect_to :back
  end

  def update_reviews
    @event = Event.find(params[:id])
    @event.event_ratings.each {|er| er.delete}
    updated = @event.update_attributes(permitted_params.event) if params[:event]
    if updated or params[:event].nil?
      @event.vendors.each do |vendor|
        vendor.trigger_reviews_rollup
      end
      @event.account.trigger_reviews_rollup
      flash[:notice] = "Reviews saved successfully."
      redirect_to token_path(:status => "Reviews saved." )
    else
      flash[:error] = "Error saving reviews - " + @event.errors.full_messages.join(", ")
      redirect_to token_path(:status => "Error" )
    end
  end

  def claim_event
    @event = Event.find(params[:id])
    if @event.event_owner_id
      flash[:error] = "Sorry! The event has already been claimed."
    else
      if @event.update_attributes({event_owner_id: current_user.id, claimed_at: Time.now})
        flash[:notice] = "Event claimed successfully."
      else
        flash[:error] = "Error claiming event - " + @event.errors.full_messages.join(", ")
      end
    end
    redirect_to :back
  end

  def fetch_cards
    @event = Event.find(params[:id])
    # The system user is not a real user, don't show him as one.
    user = @event.event_transaction_method.user if @event.event_transaction_method.user_id != 0
    render partial: "events/partials_payment/cards/index", locals: {user: user, show_new_card: true}
  end

  def show_card
    render partial: "events/partials_payment/card/show" 
  end

  def new_card
    user = User.find(params[:user_id])
    authorize! :add_card, user
    
    params[:card][:options] ||= {}
    params[:card].merge!(customer_id: user.braintree_identity)[:options].merge!(verify_card: true)
    result = Braintree::CreditCard.create(params[:card])
    if result.success?
      flash[:notice] = "Card Added Successfully"
      update_card_meta( result.credit_card.token, user.id, params[:nickname], params[:account_id])
    else
      flash[:error] = "Error adding card - #{result.message}" unless result.success?
    end
    redirect_to :back
  end

  def event_documents
    @event = Event.find(params[:event_id])
    @documents = @event.documents.all

    render partial: "events/partials_financials/documents"
  end

  private
    def update_card_meta token, user_id, nickname, account_id
      user = User.find user_id
      card = Card.find_or_create_by_token_and_user_id(token, user_id)
      account_id = nil unless user.is_admin?(account_id)
      card.update_attributes(nickname: nickname, account_id: account_id)
      if (params[:card][:options] and params[:card][:options]["make_default"] == "true") or user.default_billing_id.nil?
        user.update_attributes(:default_billing_id => card.id, :default_account_id => nil, :payment_method => 'credit_card')
      end
    end

end
