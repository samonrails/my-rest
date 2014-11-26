module SearchSortPaginateHelper

  # a link which can be displayed in the header of a table, used to switch the order_by clause used in the controller
  def ssp_sort_link column, options={}
    
    title = options[:title] || column.to_s.titleize
    sort_column = params[:sort].present? ? params[:sort] : "id"
    sort_direction =  %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    
    css_class = column.to_s == sort_column.to_s ? "sortable current #{sort_direction}" : 'sortable'
    direction = column.to_s == sort_column.to_s && sort_direction == "desc" ? "asc" : "desc"
    
    url_params = params.merge(
      :sort => column.to_s, 
      :direction => direction, 
      :page => nil,
      :meta_data => options[:meta_data]
    )

    # are we putting the direction icon sprite into this link
    if column.to_s == sort_column.to_s
      # title = content_tag(:span, title) + icon(sort_direction == "asc" ? ' icon-chevron-up' : 'icon-chevron-down')
      title = icon(sort_direction == "asc" ? 'icon-arrow-up' : 'icon-arrow-down') + content_tag(:span, title)
    end

    link_to title, url_params, {:class => css_class}
  end
  
  # a select box used to set the per_page parameter when working with a table view
  def per_page_select_html
    
    options = [10,20,50,100,250].collect{|x| [
      "#{x} per page", 
      url_for(params.merge(:per_page => x))
    ]}
    
    current_selected = url_for(params.merge(:per_page => per_page))
    
    select_tag "per_page", options_for_select(options, current_selected)
    
  end

  # the search form, built dynamically from the search fields for the provided model class
  def ssp_search_form active_record_class, additional_search_fields=[], additional_parameters={}, parent_model=nil
    # we want the parent_model parameter to be optional on each models search_fields method 
    search_fields = (parent_model.nil? ? active_record_class.default_search_fields : active_record_class.default_search_fields(parent_model)).concat(additional_search_fields)
    render 'shared/search_form', :search_fields => search_fields, :additional_parameters => additional_parameters
  end

  # Method to help if a column should be shown or not
  def column_display param, column_name
    defined?(param[:searchable][:col]).nil? ? true : param[:searchable][:col].include?(column_name) ? true : false
  end  

  def label_to_display search_fields, filter_type
    field_name = search_fields[:name].to_s
    account_label = request.path == '/admin/general_reports' and field_name == "created_at"
    event_label = field_name == 'event_start_time'
    if filter_type == "start_time"
      if account_label
        label = "Show Accounts Created From"
      else
        label= search_fields[:label] || field_name.titlecase
        label = "#{label} from" unless event_label
      end
    else
      if account_label
        label = "Show Accounts Created To"
      else
        label = event_label ? "Event End Time" : "To"
      end
    end
    label
  end
end