module EventsHelper
  
  def account_select
    Account.all.map { |account| [account.name, account.id]}
  end

  def vendor_select
    Vendor.all.map { |vendor| [vendor.name, vendor.id]}
  end

  def menu_select
    MenuTemplate.all.map { |menu| [menu.name, menu.id]}
  end

  def feedback_status_label(status)
    case status
      when "sent"
        return "label label-info"
      when "reviewed"
        return "label label-success"
    end
  end

  def voucher_total
    @event.voucher_groups.inject(Money.new(0)) { |sum, voucher_group| sum + voucher_group.total}
  end

  def card user
    if @event.event_transaction_method.transaction_card_token
      begin
        return Braintree::CreditCard.find @event.event_transaction_method.transaction_card_token
      rescue Braintree::NotFoundError => e
        Rails.logger.error "Braintree Error: #{e}"
      end
    end
      # Assuming the card selected is in the select_tag is probably a bad idea. 
      # We should add the selected card to the list and throw an error to alert new relic. -djb
    cards(user).select{|cc| cc.default?}.first
  end
  
  def cards user 
    # abstract braintree into the external service lib and get rid of the test question. -djb
    Braintree::Customer.find(user.braintree_identity).credit_cards unless Rails.env.test?
  end

  def payment_cards cards
    cards.collect{|card| ["#{card.card_type}: #{Card.find_by_token(card.token).try(:nickname)} (#{card.last_4})", card.token]}
  end

  def event_claimed_time
    if @event.claimed_at 
      timezone = @event.location.try(:building).try(:timezone)
      timezone ? @event.claimed_at.in_time_zone(timezone).strftime("%m/%d/%Y at %I:%M %P %Z") : @event.claimed_at 
    else 
      "Not Claimed Yet"
    end
  end

  def order_placed_time
    timezone = ActiveSupport::TimeZone['Central Time (US & Canada)']
    @event.order.created_at.in_time_zone(timezone).strftime("%B %d, %Y at %I:%M %p %Z")
  end

end