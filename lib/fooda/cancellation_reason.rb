class CancellationReason

  # Simple value object.
  TYPES = {
    "perks" => %w{no_staff_emergency misread_schedule event_canceled_by_account},
    "select" => %w{event_canceled_by_account restaurant_canceled},
    "managed_services" => %w{meeting_canceled multiple_proposals budget out_of_network_request change_to_recurring_schedule}
  }

  def self.available_values
    TYPES.values.flatten.uniq
  end

  def self.all
    TYPES.values.flatten.uniq
  end

  def self.no_staff_emergency
    return 'no_staff_emergency'
  end

  def self.misread_schedule
    return 'misread_schedule'
  end

  def self.event_canceled_by_account
    return 'event_canceled_by_account'
  end

  def self.restaurant_canceled
    return 'restaurant_canceled'
  end

  def self.meeting_canceled
    return 'meeting_canceled'
  end

  def self.multiple_proposals
    return 'multiple_proposals'
  end

  def self.budget
    return 'budget'
  end

  def self.out_of_network_request
    return 'out_of_network_request'
  end

  def self.change_to_recurring_schedule
    return 'change_to_recurring_schedule'
  end

  def self.find_parent product
    TYPES.each do |key, value|
      if value.include?(product)
        return key
      end
    end
    return nil
  end
  
  def self.get_available_reasons product_type
    TYPES[product_type]
  end
end

