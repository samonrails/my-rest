module SearchEventsFormHelper
 
  def default_event_start_times (event_start_time_from, event_start_time_to)
    if ( event_start_time_from.nil? || event_start_time_from.empty? ) && ( event_start_time_to.nil? || event_start_time_to.empty? )
    	event_start_time_from = (Date.today-7).strftime("%d %B %Y - 12:00 AM")
    	event_start_time_to = (Date.today+14).strftime("%d %B %Y - 11:59 PM")

    elsif event_start_time_from.nil? || event_start_time_from.empty?
    	event_start_time_from = (Date.parse(current_to_value)-14).strftime("%d %B %Y - 11:59 PM")

    elsif event_start_time_from.nil? || event_start_time_from.empty?
    	event_start_time_from = (Date.parse(current_from_value)+14).strftime("%d %B %Y - 12:00 AM")

    end

    return event_start_time_from, event_start_time_to
    	    
  end
end