module ApplicationHelper

  def flash_class(type)
    case type
    when :alert
      "alert-error"
    when :error
      "alert-error"
    when :notice
      "alert-success"
    else
      ""
    end
  end

  def body_class
    "#{ controller_name }"
  end

  def body_id
    # Use a double underscore separator since the controller or action name may have
    # a single underscore within them.
    "#{ controller_name }__#{ action_name }"
  end

  def all_inventory_items_for_vendor vendor_id
    Vendor.find(vendor_id).inventory_items.map { |a| [a.name, a.id]}
  end

  # dynamically adding nested fields
  # ------------------------------------------

  def link_to_add_fields(name, f, association, additional_params={})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    data = {id: id, fields: fields.gsub("\n", "")}
    data[:insertion_point] = additional_params[:insertion_point] unless additional_params[:insertion_point].nil?
    link_to(name, '#', class: "add_fields " + (additional_params[:class].nil? ? "" : additional_params[:class]), data: data)
  end

  # help with links
  ## ---------------------
  def url_with_protocol url
    /^http/.match(url) ? url : "http://#{url}"
  end

  def friendly_boolean field
    field ? "Yes" : "No"
  end

  def icon name
    css_class = "icon #{name}"
    content_tag(:i, nil, :class => css_class)
  end

  def find_capacity(vendor,day)
    vendor.capacities.find_by_day(day)
  end

  def average_rating(array)
    (array.sum/array.size.to_f).round(1) unless array.empty?
  end

  def is_favorite(object)
    object.evaluators_for(:favorite).include? current_user
  end

  def reviews_for_current_graph(reviews_rollup, level)
    case level
      when "Event Level Food Ratings"
        reviews = Review.find(reviews_rollup.event_level_reviews[:reviews])
        rating_array = reviews_rollup.event_level_reviews[:rating_array]
      when "Aggregate Item Level Food Ratings"
        reviews = Review.find(reviews_rollup.item_level_reviews[:reviews])
        rating_array = reviews_rollup.item_level_reviews[:rating_array]
      when "Food Presentation"
        reviews = Review.find(reviews_rollup.food_presentation_reviews[:reviews])
        rating_array = reviews_rollup.food_presentation_reviews[:rating_array]
      when "Order Accuracy"
        reviews = Review.find(reviews_rollup.order_accuracy_reviews[:reviews])
        rating_array = reviews_rollup.order_accuracy_reviews[:rating_array]
      when "On Time Delivery"
        reviews = Review.find(reviews_rollup.delivery_reviews[:reviews])
        rating_array = reviews_rollup.delivery_reviews[:rating_array]
      when "Ease of Ordering"
        reviews = Review.find(reviews_rollup.ease_of_ordering_reviews[:reviews])
        rating_array = reviews_rollup.ease_of_ordering_reviews[:rating_array]
      when "Customer Service"
        reviews = Review.find(reviews_rollup.customer_service_reviews[:reviews])
        rating_array = reviews_rollup.customer_service_reviews[:rating_array]
    end
    return reviews, rating_array
  end

  def braintree_links(ph)
    case ph.status
      when "authorized"
        link_to('Settle', '#', class: 'btn btn-success btn-mini btn-settle', trans_id: ph.transaction_id, amount: ph.amount) +
        link_to('Void', '#', class: 'btn btn-danger btn-mini btn-void', trans_id: ph.transaction_id)
      when "submitted_for_settlement"
        link_to('Void', '#', class: 'btn btn-danger btn-mini btn-void', trans_id: ph.transaction_id)
      when "settled"
        link_to('Refund', '#', class: 'btn btn-danger btn-mini btn-refund', trans_id: ph.transaction_id, amount: ph.amount)
    end
  end

  def time_zone_abbreviation(building)
    return '' unless building
    time_zone = ActiveSupport::TimeZone.find_tzinfo(building.try(:timezone)).strftime('%Z')

    # In case nothing is returned
    if time_zone.nil?
      time_zone = ''
    end
    return time_zone
  end

  def pretty_vendors(vendors)
    event_vendors.map {|v| v.vendor.name}.join(", ")
  end

  def pretty_id(id)
    "#{id.to_s.rjust(7, "0")}"
  end

  def pretty_status(status)
    status.tr('_', ' ').gsub(/\b\w/){|s| s.capitalize!}
  end

  def link_to_modal(path, args={})
    button = args.delete(:button)
    icon   = args.delete(:icon)
    text   = args.delete(:text)
    lopts  = {class: "btn btn-mini btn-#{button}", data: {toggle: "modal", target: "#app-modal"}}
    iopts  = "icon icon-white icon-#{icon}"
    delete = {data: {method: "delete", confirm: 'Are you sure?'}}

    lopts.merge!(delete) if args.delete(:delete)

    link_to path, lopts do
      "<i class=\"#{iopts}\"></i>#{text}".html_safe
    end
  end


  def created_by(event)
    event.created_by.nil? ? '-' : event.created_by.name
  end

  def created_at_cst (created_at_datetime)
    created_at_datetime.in_time_zone(ActiveSupport::TimeZone['Central Time (US & Canada)'])
  end

end
