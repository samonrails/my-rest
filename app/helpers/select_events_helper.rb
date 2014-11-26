module SelectEventsHelper

	def select_event_vendor_list ( select_event, edit_vendor = nil )
    SelectEventVendorCuisine.select_event_vendor_list( select_event, edit_vendor )
  end

	def email_list_id ( select_event )
		# If the email list ID does not exist for an event, inherit it from the account

		if select_event.email_list_id.nil?
			select_event.account.try(:account_email_lists).try(:first).try(:list_id) || ''
		else
			select_event.email_list_id
		end
	end

  def default_delivery_time ( select_event )
    if select_event.delivery_time.present?
      select_event.delivery_time.to_s(:full_date_time)
    end
  end

  def default_ordering_window_start_time( select_event )
    if select_event.ordering_window_start_time.present?
      select_event.ordering_window_start_time.to_s(:full_date_time)
    end
  end

  def default_ordering_window_end_time( select_event )
    if select_event.ordering_window_end_time.present?
      select_event.ordering_window_end_time.to_s(:full_date_time)
    end
  end

  def ready_bagged ( select_event )
    if select_event.ready_and_bagged.present?
      select_event.ready_and_bagged
    end
  end

  def default_introduction_email_time (select_event)
  	# Finds the default email introduction time. 
  	# If none exists, it will be the previous day of the delivery time at 2pm

  	date = if select_event.introduction_email_time.nil?
	  	((select_event.delivery_time - 1.day).beginning_of_day + 14.hours)
		else 
			(select_event.introduction_email_time)
  	end

    date.to_s(:full_date_time)
  	
  end


  def default_final_email_time (select_event)
  	# Finds the default email introduction time. 
  	# If none exists, it will be the previous day of the delivery time at 2pm
  	
  	date = if select_event.final_email_time.nil?
	  	((select_event.delivery_time).beginning_of_day + 8.hours)
		else 
			(select_event.final_email_time)
  	end

  	date.to_s(:full_date_time)
  end

  def existing_account_users( select_event )
    select_event.try(:account).try(:users).collect{|u| [u.full_name, u.id]}
  end

end
