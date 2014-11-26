class VendorsController < ApplicationController
  authorize_resource
  respond_to :html, :js, :json

  def index
    respond_with @vendors = Kaminari.paginate_array(Vendor.includes([:products, :vendor_manager, :cuisines, :markets, { :taggings => :tag } ]).all).page(params[:page])
  end

  def show
    if params[:xls] && !params[:meta_data].nil? && params[:meta_data] == "events"
      redirect_to :action => "export_events", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
    else
      @vendor = Vendor.find(params[:id])
      options = {:artificial_attributes => {"vendor"=>"vendors.name", "account"=>"accounts.name", "event_time" => "event_start_time", "date" => "event_start_time"}}
      
      params[:searchable] ||= {}
      params[:searchable][:vendor_id] = @vendor.id
      
      begin
        @events = Event.search "*", index_name: Search.indexes_to_search, query: Search.where_clauses_es( params ), order: Search.order_options( params ), include: [[:account => :account_exec], :vendors, [:location => [:building => :market]] ], page: params[:page], per_page: 15
      rescue
        flash[:error] = "Could not retrieve events from ElasticSearch - showing the last 10 events."
        @events = Kaminari.paginate_array(Event.last(5) + SelectEvent.last(5)).page(params[:page])
      end
      if !params[:meta_data].nil? && params[:meta_data] == "events"
        redirect_to vendor_path(@vendor, :selected => "events", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort])
      end
    end
  end

  def export_events
    @vendor = Vendor.find(params[:id])
    
    respond_to do |format|
      format.xls do
        options = {:artificial_attributes => {"vendor"=>"vendors.name", "account"=>"accounts.name", "event_time" => "event_start_time", "date" => "event_start_time"}}
        params[:searchable] ||= {}
        params[:searchable][:vendor_id] = @vendor.id
        begin
          @events = Event.search "*", index_name: Search.indexes_to_search, query: Search.where_clauses_es( params ), order: Search.order_options( params ), include: [[:account => :account_exec], :vendors, [:location => [:building => :market]] ], page: params[:page]
        rescue
          @events = Event.last(5) + SelectEvent.last(5)
        end
        headers["Content-Disposition"] = "attachment; filename=\"vendor_events.xls\""
      end
    end
  end

  def edit
    @vendor = Vendor.find params[:id]
  end

  def new
    @vendor = Vendor.new
    @vendor.address = Address.new
  end

  def create
    @vendor = Vendor.create(permitted_params.vendor)

    if @vendor.save
      flash[:notice] = "Vendor created successfully."
      redirect_to @vendor
    else
      flash[:error] = "Error creating vendor - " + @vendor.errors.full_messages.join(", ")
      redirect_to vendors_url
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    begin
      @vendor.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destroying Vendor - " + e.to_s
    end
    respond_with @vendor
  end

  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|

      format.html do
        if @vendor.update_attributes(permitted_params.vendor)
          flash[:notice] = "Vendor updated successfully."
        else
          flash[:error] = "Error updating vendor - " + @vendor.errors.full_messages.join(", ")
        end
        if params[:vendor][:address_attributes]
          redirect_to vendor_path(@vendor, :selected => "finance")
        elsif params[:vendor][:min_capacity]
          redirect_to vendor_path(@vendor, :selected => "capacity")
        else
          redirect_to @vendor
        end
      end

      format.js do
        if @vendor.update_attributes(permitted_params.vendor)
          head :ok
        else
          head :bad_request
        end
      end
    end
  end

  def get_vendors_by_cuisine_and_product_and_market_and_account

    if params[:event_vendor_type].present?
      # Select events look up for restaurant types only
      vendors = Vendor.vendors_by_type_and_product_and_market(params[:product], params[:event_vendor_type], params[:market])
    else
      vendors = Vendor.vendors_by_product_and_market(params[:product], params[:market])
    end

    account = Account.find(params[:account_id])

    if params[:cuisine] != "Any"
      vendors = vendors.select{|v| v.cuisine_list.include?(params[:cuisine])}
    end

    favorite_vendors = account.favorite_vendors.sort & vendors
    # favorite_accounts_by_vendor = account.vendors_that_favor_this_account.sort & vendors
    do_not_schedule_vendors = account.do_not_schedule_vendors.sort & vendors
    vendors_neutral = vendors - favorite_vendors - do_not_schedule_vendors

    @vendors = {}
    @vendors["Favorite Vendors"] = favorite_vendors unless favorite_vendors.count < 1
    # @vendors["Vendors That Favor This Account"] = favorite_accounts_by_vendor unless favorite_accounts_by_vendor.count < 1
    @vendors["Neutral"] = vendors_neutral unless vendors_neutral.count < 1
    @vendors["Do Not Schedule"] = do_not_schedule_vendors unless do_not_schedule_vendors.count < 1

    respond_with(@vendors)
  end

  def get_vendors_by_cuisine_and_product_and_location_and_account
    if defined?(Location.find(params[:location]).building.market.name)
      params[:market] = Location.find(params[:location]).building.market.name
      get_vendors_by_cuisine_and_product_and_market_and_account
    else
      respond_with([])
    end
  end

  def get_vendor_menu_templates_by_product
    respond_with(Vendor.find(params[:id]).menu_templates_by_product(params[:product]))
  end

  def get_vendor_menu_templates
    respond_with(Vendor.find(params[:id]).menu_templates)
  end
  
  def export_item_reviews
    @vendor = Vendor.find(params[:id])
    respond_to do |format|
      format.xls do
        inventory_items_for_pt = @vendor.inventory_items.select{|i| i.inventory_item_product_types.map(&:product_type).include?(params[:product_type])}
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

  def toggle_favorite
    @vendor = Vendor.find params[:id]
    unless @vendor.evaluators_for(:favorite).include? current_user
      @vendor.add_or_update_evaluation(:favorite, 1, current_user)
       alert = "Added to Favorites."
    else
       @vendor.delete_evaluation(:favorite, current_user)
        alert = "Removed from Favorites."
    end
    render json: alert
  end

  def export_event_reviews
    @vendor = Vendor.find(params[:id])
    respond_to do |format|
      format.xls do
        @events = @vendor.event_vendors.map(&:event).select{|e| Product.find_parent(e.product) == params[:product_type]}
        @rating = params[:rating].to_i if params[:rating] and !params[:rating].blank?
        @level = params[:level]
        @product_type = params[:product_type]
        headers["Content-Disposition"] = "attachment; filename=\"#{params[:level]}.xls\""
      end
    end
  end

  def export_presentation_reviews
    @vendor = Vendor.find(params[:id])
    respond_to do |format|
      format.xls do
        events = @vendor.event_vendors.map(&:event).select{|e| Product.find_parent(e.product) == params[:product_type]}
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
    @vendor = Vendor.find(params[:id])
    respond_to do |format|
      format.xls do
        @events = @vendor.event_vendors.map(&:event).select{|e| Product.find_parent(e.product) == params[:product_type]}
        @items = @vendor.inventory_items.select{|i| i.inventory_item_product_types.map(&:product_type).include?(params[:product_type])}
        @level = params[:level]
        @product_type = params[:product_type]
        headers["Content-Disposition"] = "attachment; filename=\"bar_graph_reviews.xls\""
      end
    end
  end
end
