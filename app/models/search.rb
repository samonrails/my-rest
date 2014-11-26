class Search

  # Build search options for ElasticSearch
  def self.where_clauses_es(params)
    q = {}
    term_searches = []
    params[:searchable] ||= {}
    
    if params[:searchable][:vendor].present?
      term_searches << { query_string: { fields: ["vendor_names"], query: '*' +  params[:searchable][:vendor].downcase + '*' } } 
    end

    if params[:searchable][:vendor_id].present?
      term_searches << { match: { vendor_id: params[:searchable][:vendor_id]}}
    end

    if params[:searchable][:account].present?
      term_searches << { query_string: { fields: ["account_names"], query: '*' +  params[:searchable][:account].downcase + '*' } } 
    end

    if params[:searchable][:account_id].present?
      term_searches << { match: { account_id: params[:searchable][:account_id]}}
    end

    if params[:searchable][:account_executive].present?
      term_searches << { match: { account_executive: params[:searchable][:account_executive].downcase}}
    end

    # Set the default dates
    default_dates ( params )

    if params[:searchable][:event_start_time_from].present? or params[:searchable][:event_start_time_to].present?

      date_params = {}
      
      if params[:searchable][:event_start_time_from].present?
        date_from = DateTime.parse( params[:searchable][:event_start_time_from] )
        date_params[:from] = date_from
      end

      if params[:searchable][:event_start_time_to].present?
        date_to = DateTime.parse( params[:searchable][:event_start_time_to] )
        date_params[:to] = date_to
      end

      term_searches << { :range => { :event_start_time => date_params }}
    end


    if params[:searchable][:market].present?
      term_searches << { terms: { markets:  params[:searchable][:market].map(&:downcase) } }        
    end

    if params[:searchable][:status].present?
      term_searches << { terms: { status:  params[:searchable][:status].map(&:downcase) } } 
    end

    if params[:searchable][:product].present?
      term_searches << { terms: { product:  params[:searchable][:product].map(&:downcase) } } 
    end

    if term_searches.count > 0 
      q =  {bool: { must: term_searches } } 
    else
      q = nil
    end

    q

  end

  def self.indexes_to_search
    [Event.searchkick_index.name, SelectEvent.searchkick_index.name]
  end

  def self.order_options( params )
    if params[:sort].blank?
      params[:sort] = "created_at"
    end

    sort_asc_descending = params[:direction] || "desc"
    
    { params[:sort]  =>  sort_asc_descending }
  end

  def self.default_dates( params )
    # Legacy code - Default the range to be 14 days if one of more of the dates is not provided
    if (params[:searchable][:event_start_time_from].nil? || params[:searchable][:event_start_time_from].empty? ) && ( params[:searchable][:event_start_time_from].nil? || params[:searchable][:event_start_time_to].empty? )
        params[:searchable][:event_start_time_from] = (Date.today-7).strftime("%d %B %Y - 12:00 AM")
        params[:searchable][:event_start_time_to] = (Date.today+14).strftime("%d %B %Y - 11:59 PM")
    elsif (params[:searchable][:event_start_time_from].nil? or params[:searchable][:event_start_time_from].empty?)
        params[:searchable][:event_start_time_from] = (Date.parse(params[:searchable][:event_start_time_to])-14).strftime("%d %B %Y - 12:00 AM")
    elsif (params[:searchable][:event_start_time_to].nil? or params[:searchable][:event_start_time_to].empty?)
        params[:searchable][:event_start_time_to] = (Date.parse(params[:searchable][:event_start_time_from])+14).strftime("%d %B %Y - 11:59 PM")
    end

  end
end
