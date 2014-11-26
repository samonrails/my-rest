class SelectEventVendorCuisine
  
  def self.select_event_vendor_list ( select_event, edit_vendor = nil )

    vendors = {}
    vendors[:initial_vendors] = []
    select_product_type = ProductType.select

    vendors[:product_type] = select_product_type

    if select_event.try(:location).try(:building).try(:is_approved?)
      # Various iteration methods depending on the type of Event
      if select_event.is_a?(SelectEvent)
        vendors[:initial_vendors] = Vendor.vendors_by_type_and_product_and_market(select_product_type, 'Restaurant', select_event.location.building.try(:market).try(:name)) - select_event.select_event_vendors.map{|ev| ev.vendor}

      elsif select_event.is_a?(SelectEventSchedule)
        vendors[:initial_vendors] = Vendor.vendors_by_type_and_product_and_market(select_product_type, 'Restaurant', select_event.location.building.try(:market).try(:name)) - select_event.select_event_schedule_vendors.map{|ev| ev.vendor}
      end
    end

    if ( edit_vendor.present? )
      vendors[:initial_vendors] =  [edit_vendor.vendor]
    end

    vendors[:vendors_favorite] = select_event.account.favorite_vendors.sort & vendors[:initial_vendors]
    vendors[:vendors_do_not_schedule] = select_event.account.do_not_schedule_vendors.sort & vendors[:initial_vendors]
    vendors[:vendors_neutral] = vendors[:initial_vendors] - vendors[:vendors_favorite] - vendors[:vendors_do_not_schedule]

    vendor_ids = [ (vendors[:initial_vendors].map{|v| v.id } )]
    vendors[:available_cuisines] = Tagging.includes(:tag).where( taggable_id: vendor_ids, context: 'cuisines' )
    vendors[:available_cuisines] =  (vendors[:available_cuisines].map{|v| v.tag.name }.flatten.uniq).sort
 
    vendors[:cuisines_favorite] = select_event.account.cuisines_favorite.sort & vendors[:available_cuisines]
    vendors[:cuisines_do_not_schedule] = select_event.account.cuisines_do_not_schedule.sort & vendors[:available_cuisines]
    vendors[:cuisines_neutral] = vendors[:available_cuisines] - vendors[:cuisines_favorite] - vendors[:cuisines_do_not_schedule]

    vendors[:initial_menu_templates] = (vendors[:initial_vendors].count > 0 ? (vendors[:vendors_favorite] + vendors[:vendors_neutral] + vendors[:vendors_do_not_schedule]).first.menu_templates_by_product(select_product_type) : [])
   
    vendors
  end
end
