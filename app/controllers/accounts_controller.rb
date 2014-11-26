class AccountsController < ApplicationController
  authorize_resource

  respond_to :html, :json, :js

  def index
    respond_with(@accounts = Kaminari.paginate_array(Account.all).page(params[:page]))
  end

  def show
    respond_to do |format|
      format.html do
        if params[:xls] && !params[:meta_data].nil? && params[:meta_data] == "events"
          redirect_to :action => "export_events", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @account = Account.find(params[:id])
          @account_pricing_tiers = AccountPricingTier.find_all_by_account_id(params[:id])
          @malformed_locations_count = @account.bad_locations.count

          # Account email lists - if they do not exist, we must build it 
          # ( this is from accepts_nested_attributes_for )

          if @account.account_email_lists.count == 0
            @account.account_email_lists.build
          end

          options = {:artificial_attributes => {"vendor"=>"vendors.name", "event_time" => "event_start_time", "date" => "event_start_time"}}
          if !params[:searchable].present?
            params[:searchable] = {}
          end
          params[:searchable][:account_id] = @account.id
          begin
            @events = Event.search "*", index_name: Search.indexes_to_search, query: Search.where_clauses_es( params ), order: Search.order_options( params ), include: [[:account => :account_exec], :vendors, [:location => [:building => :market]] ], page: params[:page], per_page: 15
          rescue
            flash[:error] = "Could not retrieve events from ElasticSearch - showing the last 10 events."
            @events = Kaminari.paginate_array(Event.last(5) + SelectEvent.last(5)).page(params[:page])
          end
          if params[:search_parameter] && params[:search_string]
            unless params[:search_parameter] == 'search'
              @users = User.where("#{params[:search_parameter] == 'name' ? 'first_name': params[:search_parameter]} ilike ? ", (("%" + params[:search_string]) + "%") )
            else
              @users = User.where("first_name ilike ? or email ilike ?", "%#{params[:search_string]}%", "%#{params[:search_string]}%" )
            end
          else
            @users = []
          end
          @members = User.find(@account.account_roles.map(&:user_id))
          if !params[:meta_data].nil? && params[:meta_data] == "events"
            redirect_to account_path(@account, :selected => "events", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort])
          end
        end
        if request.xhr? && params[:search_parameter]
          render :partial => "accounts/list_user"
        end
      end

      format.json do
        respond_with(@account = Account.find(params[:id]).to_json)
      end

    end
  end

  def export_events
    @account = Account.find(params[:id])
    
    respond_to do |format|
      format.xls do
        params[:searchable] ||= {}
        params[:searchable][:account_id] = @account.id
        begin
          @events = Event.search "*", index_name: Search.indexes_to_search, query: Search.where_clauses_es( params ), order: Search.order_options( params ), include: [[:account => :account_exec], :vendors, [:location => [:building => :market]] ]
        rescue
          @events = Event.last(5) + SelectEvent.last(5)
        end
        headers["Content-Disposition"] = "attachment; filename=\"account_events.xls\""
      end
    end
  end

  def edit
    @account = Account.find params[:id]
  end

  def new
    @account = Account.new
    @account.address = Address.new
  end

  def create
    @account = Account.new(permitted_params.account)

    if @account.save
      flash[:notice] = "Account created."
      redirect_to @account
    else
      flash[:error] = "Error creating account - " + @account.errors.full_messages.join(", ")
      redirect_to accounts_path
    end
  end

  def update
    @account = Account.find(params[:id])

    respond_to do |format|

      format.html do
        if @account.update_attributes(permitted_params.account)
          flash[:notice] = "Account updated successfully."
        else
          flash[:error] = "Error updating account - " + @account.errors.full_messages.join(", ")
        end
        redirect_to @account
      end

      format.js do
        if @account.update_attributes(permitted_params.account)
          head :ok
        else
          head :bad_request
        end
      end
    end
  end

  def destroy
    @account = Account.find(params[:id])
    begin
      @account.destroy
      flash[:notice] = "Account deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying account - " + e.to_s
    end
    redirect_to @account
  end

  def associate_users
    @account = Account.find(params[:id])
    add_user_ids = params[:add_users].split(",")
    remove_ids = params[:remove_users].split(",")
    AccountRole.destroy_all(["account_id = ? and user_id in (?)", @account.id, remove_ids])
    add_user_ids.each do |user_id|
       account_role = AccountRole.find_or_create_by_user_id_and_account_id(user_id, @account.id)
   end
   redirect_to account_path(@account, :selected => "membership")
  end

  def export_item_reviews
    @account = Account.find(params[:id])
    respond_to do |format|
      format.xls do
        inventory_items_for_pt = @account.events.map(&:line_items).flatten.map(&:inventory_item).compact.select{|i| i.inventory_item_product_types.map(&:product_type).include?(params[:product_type])}
        @reviews = inventory_items_for_pt.map{|i| i.reviews.order("created_at")}.flatten
        if params[:rating] and !params[:rating].blank?
          @reviews = @reviews.select{|review| review.rating == params[:rating].to_i}
        end
        @level = params[:level]
        @product_type = params[:product_type]
        headers["Content-Disposition"] = "attachment; filename=\"#{params[:level]}.xls\""
      end
    end
  end

  def export_event_reviews
    @account = Account.find(params[:id])
    respond_to do |format|
      format.xls do
        @events = @account.events.select{|e| Product.find_parent(e.product) == params[:product_type]}
        @rating = params[:rating].to_i if params[:rating] and !params[:rating].blank?
        @level = params[:level]
        @product_type = params[:product_type]
        headers["Content-Disposition"] = "attachment; filename=\"#{params[:level]}.xls\""
      end
    end
  end

  def export_presentation_reviews
    @account = Account.find(params[:id])
    respond_to do |format|
      format.xls do
        events = @account.events.select{|e| Product.find_parent(e.product) == params[:product_type]}
        @reviews = events.map(&:event_ratings).flatten.select{|e| e.additional_event_ratings == params[:level]}.flatten
        if params[:rating] and !params[:rating].blank?
          @reviews = @reviews.select{|review| review.rating == params[:rating].to_i}
        end
        @level = params[:level]
        @product_type = params[:product_type]
        headers["Content-Disposition"] = "attachment; filename=\"#{params[:level]} Reviews.xls\""
      end
    end
  end

  def export_bar_graph_data
    @account = Account.find(params[:id])
    respond_to do |format|
      format.xls do
        @events = @account.events.select{|e| Product.find_parent(e.product) == params[:product_type]}
        @items = @account.events.map(&:line_items).flatten.map(&:inventory_item).compact.select{|i| i.inventory_item_product_types.map(&:product_type).include?(params[:product_type])}
        @level = params[:level]
        @product_type = params[:product_type]
        headers["Content-Disposition"] = "attachment; filename=\"bar_graph_reviews.xls\""
      end
    end
  end

end
