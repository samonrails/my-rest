module SelectOrdersHelper

	def select_order_date(select_order)
		select_order.select_event.delivery_time.strftime("%Y-%m-%d")
	end

	def select_order_time(select_order)
		select_order.select_event.delivery_time.strftime("%I:%M %p") 
	end

	def select_order_item_count(select_order)
    quantity = 0
		select_order.select_order_items.each {|item| quantity += item.quantity || 0}
    quantity
	end

  def select_order_vendors(select_order)
    vendors = []
    select_order.select_order_items.each do |order_item|
      vendor_name = order_item.inventory_item.vendor.name 
      vendors << vendor_name unless vendors.include?(vendor_name)
    end
    vendors.join(", ")
  end

  def select_order_customized(select_order)
    select_order.select_order_items.select{|i| i.special_instructions != ""}.count
  end


  def select_order_status(select_order)
    if last_transaction = select_order_recent_transaction(select_order)
      if last_transaction.status == "authorized"
        return "Paid"
      elsif last_transaction.status == "voided"
        return "Refunded"
      end
    else
      return "In Progress"
    end
  end

  def select_order_additional_charges(select_order)
    if select_order.tax_amount.nil? || select_order.gratuity_amount.nil? || select_order.delivery_amount.nil?
      return "$#{Money.new(0)}"
    else
      "$#{select_order.tax_amount + select_order.gratuity_amount + select_order.delivery_amount}"
    end
  end

  def select_order_subtotal(select_order)
    return "$#{select_order.subtotal_amount}" if select_order.subtotal_amount
    "$#{Money.new(0)}"
  end

  def select_order_subsidy(select_order)
    return "$#{select_order.subsidy_amount}" if select_order.subsidy_amount
    "$#{Money.new(0)}"
  end

  def select_order_total(select_order)
    return "$#{select_order.total_amount}" if select_order.total_amount
    "$#{Money.new(0)}"
  end
  # Select Order Transaction Helper Methods

  def select_order_transactions_desc(select_order)
    select_order.select_order_transactions.order('created_at desc') || []
  end

  def select_order_recent_transaction(select_order)
    select_order_transactions_desc(select_order).first
  end
  
  def select_order_transaction_card_long(transaction)
    return "" if transaction.nil?
    "#{transaction.card_type} #{transaction.cc_last4} exp. #{transaction.expiration_date}"
  end

  def select_order_transaction_card_short(transaction)
    return "N/A" if transaction.nil?
    "#{transaction.card_type} #{transaction.cc_last4}"
  end

  def select_order_transaction_amount(transaction)
    return "$#{Money.new(0)}" if transaction.nil?
    "$#{transaction.amount}"
  end


end