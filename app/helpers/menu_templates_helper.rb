module MenuTemplatesHelper

  def average_per_person_price(menu_template)
    inventory_items = menu_template.inventory_items
    unless inventory_items.blank?
      average_sell_price = 0
      average_feed_qty = 0
      average_sell_price = inventory_items.map {|i| i.calculate_sell_price_using_standard_pricing_tier}.sum
      average_feed_qty = inventory_items.map {|i| i.min_feeds}.sum
      average_per_person_price = average_sell_price.to_f / average_feed_qty
      "$ #{average_per_person_price.round(2)}"
    else
      "No item added yet"
    end
  end
end