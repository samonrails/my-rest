module SearchEventsHelper

  def search_event_sort_url( path, field, params )

    direction = params[:direction] || "desc"
    current_sort_field = params[:sort]

    if current_sort_field == field
      if direction == "desc"
        direction = "asc"
      elsif direction == "asc"
        direction = "desc"
      end
    else
      direction = "desc"
    end

    path + "/?" + params.to_query + "&amp;sort=" + field + "&amp;direction=" + direction
  end

  def search_event_arrow( field, current_search_field, direction )
    arrow = ''
    if field == current_search_field
      if direction == "asc"
        arrow = '<i class="icon icon-arrow-up"></i>'
      else
        arrow = '<i class="icon icon-arrow-down"></i>'
      end
    end
      arrow.html_safe
  end
    
end
