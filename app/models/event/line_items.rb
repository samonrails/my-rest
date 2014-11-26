module Event::LineItems

  # Common filtering method
  # ---------------------------------------------------------------------------
  def filter_invoiced line_items, invoiced, document_id
    if invoiced.nil?
      # If no invoice ID is specified, then select all the line items
      # which do not have a parent.  Otherwise, we will be double-counting.
      line_items.select{|li| li.parent_id.nil?}
    elsif !invoiced
      line_items.select{|li| li.document_id.nil?}
    elsif document_id.nil?
      line_items.select{|li| !li.document_id.nil?}
    else
      line_items.select{|li| li.document_id == document_id}
    end
  end

  # By Payable Party
  # ---------------------------------------------------------------------------
  def line_items_per_person_charge_by_payable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.payable_party == party && li.line_item_sub_type == "Menu-Fee" && !li.after_subtotal)}, invoiced, document_id)
  end

  def line_items_no_price_menu_items_by_payable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.payable_party == party && li.line_item_sub_type == "Menu-Item" && !li.include_price_in_expense && !li.after_subtotal)}, invoiced, document_id)
    .sort_by{|e| [MealType.available_values.index(e.inventory_item.meal_type)]}
  end

  def line_items_with_price_menu_items_by_payable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.payable_party == party && li.line_item_sub_type == "Menu-Item" && li.include_price_in_expense && !li.after_subtotal)}, invoiced, document_id)
    .sort_by{|e| [MealType.available_values.index(e.inventory_item.meal_type)]}
  end

  def line_items_non_menu_items_by_payable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.payable_party == party && li.line_item_sub_type != "Menu-Item" && li.line_item_sub_type != "Menu-Fee" && !li.after_subtotal)}, invoiced, document_id)
  end

  def line_items_after_subtotal_by_payable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.payable_party == party && li.after_subtotal)}, invoiced, document_id)
  end

  # By Billable Party
  # ---------------------------------------------------------------------------
  def line_items_vendor_per_person_charge_by_billable_party party, vendor, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && li.per_person_price_for_vendor(vendor) && !li.after_subtotal)}, invoiced, document_id)
  end

  def line_items_vendor_no_price_menu_items_by_billable_party party, vendor, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && li.menu_item_for_vendor(vendor) && !li.include_price_in_revenue && !li.after_subtotal)}, invoiced, document_id)
    .sort_by{|e| [MealType.available_values.index(e.inventory_item.meal_type)]}
  end

  def line_items_vendor_menu_items_with_price_by_billable_party party, vendor, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && li.menu_item_for_vendor(vendor) && li.include_price_in_revenue && !li.after_subtotal)}, invoiced, document_id)
    .sort_by{|e| [MealType.available_values.index(e.inventory_item.meal_type)]}
  end

  def line_items_no_associated_vendor_by_billable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && !li.associated_with_vendor && !li.after_subtotal)}, invoiced, document_id)
  end

  def line_items_fixed_by_billable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && !li.percentage_of_subtotal)}, invoiced, document_id)
  end

  def line_items_fixed_by_billable_party_including_add_ons party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.billable_party == party && !li.percentage_of_subtotal)}, invoiced, document_id)
  end

  def line_items_after_subtotal_percentage_by_billable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && li.after_subtotal && li.percentage_of_subtotal)}, invoiced, document_id)
  end

  def line_items_after_subtotal_fixed_by_billable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && li.after_subtotal && !li.percentage_of_subtotal)}, invoiced, document_id)
  end

  def line_items_after_subtotal_by_billable_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && li.after_subtotal)}, invoiced, document_id)
  end

  def line_items_for_delivery_fee_by_party party, invoiced=nil, document_id=nil
    filter_invoiced(line_items.select{|li| (li.add_on_parent_id.nil? && li.billable_party == party && li.parent_id.nil? && li.sku == "999104")}, invoiced, document_id)
  end

  # Return all menu items
  # ---------------------------------------------------------------------------
  def menu_items
    line_items.where(["inventory_item_id > 0"])
  end

  # Return all inventory items for which there are line items
  # ---------------------------------------------------------------------------
  def inventory_items_on_menu
    line_items.map{|li| li.inventory_item}.select{|ii| !ii.nil?}
  end

  def include_expense_price_for_inventory_item inventory_item_id
    line_items.select{|li| li.inventory_item_id == inventory_item_id && li.include_price_in_expense}.count > 0 || line_items.select{|li| li.inventory_item_id == inventory_item_id}.count == 0
  end

  def include_revenue_price_for_inventory_item inventory_item_id
    line_items.select{|li| li.inventory_item_id == inventory_item_id && li.include_price_in_revenue}.count > 0 || line_items.select{|li| li.inventory_item_id == inventory_item_id}.count == 0
  end

  def quantity_of_inventory_item inventory_item_id
    line_items.select{|li| li.inventory_item_id == inventory_item_id && !li.payable_party.nil?}.inject(0) { |sum, li| sum + li.quantity }
  end

end
