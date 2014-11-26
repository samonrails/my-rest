module Event::RateEvent
  
  def rate_event(token)
    vendors.select{|v| v.vendor_type == "Restaurant"}.each do |vendor|
      event_line_items = line_items.select{|li| li.add_on_parent_id.nil? && !li.inventory_item.nil? && li.line_item_sub_type == "Menu-Item" && li.inventory_item.vendor == vendor && li.payable_party == vendor}
      inventory_items = event_line_items.map{|l| l.inventory_item}.flatten.compact
      inventory_items.each do |item|
        item.reviews.create(event_id: self.id, rating: token.data[:rating], contact: self.contact, rating_type: "group")
      end
      vendor.trigger_reviews_rollup
    end
    account.trigger_reviews_rollup
  end

  def active_tokens
    self.tokens.where('expires_at is null')
  end

  def create_active_tokens
    expire_all_tokens
    (1..5).each do |i|
      self.tokens.create(data: {rating: i})
    end
  end

  def expire_all_tokens
    self.tokens.each do |t|
      t.touch :expires_at
    end
  end
end