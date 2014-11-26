module Event::FinancialsRollup

# ---------------------------------------------------------------------------
# *** Revenue
# ---------------------------------------------------------------------------

  def revenue_retail_subtotal_by_party party, invoiced=nil, document_id=nil
    sub_total = Money.new(0)

    filter_invoiced(line_items, invoiced, document_id).each do |li|
      unless li.after_subtotal

        if li.billable_party == party and !li.inventory_item.nil?
          sub_total += li.inventory_item.retail_price
        end

        if li.payable_party == party and !li.inventory_item.nil?
          sub_total -= li.inventory_item.retail_price
        end

      end
    end
    sub_total
  end

  # Sum up the revenue (money being paid to Fooda) for all subtotal items
  # ---------------------------------------------------------------------------
  def revenue_subtotal_by_party party, invoiced=nil, document_id=nil
    sub_total = Money.new(0)

    filter_invoiced(line_items, invoiced, document_id).each do |li|
      if !li.after_subtotal

        if li.billable_party == party
          sub_total += li.revenue_total
        end

        if li.payable_party == party
          sub_total -= li.expense_total
        end

      end
    end
    sub_total
  end

  # Sum up the tax being paid on all the items in the subtotals
  # ---------------------------------------------------------------------------
  def revenue_general_tax_by_party party, invoiced=nil, document_id=nil
    tax = 0
    filter_invoiced(line_items, invoiced, document_id).each do |li|
      if !li.after_subtotal

        if li.billable_party == party
          tax += li.revenue_tax_unrounded
        end

        if li.payable_party == party
          tax -= li.expense_tax_unrounded
        end

      end
    end
    Money.new(tax*100)
  end

  # Sum up the revenue for line items of a particular sub_type
  # ---------------------------------------------------------------------------
  def revenue_by_party_and_line_item_subtype party, line_item_sub_type, invoiced=nil, document_id=nil
    sub_total = revenue_subtotal_by_party(party)
    accum = Money.new(0)

    filter_invoiced(line_items, invoiced, document_id).select{|li| li.line_item_sub_type == line_item_sub_type}.each do |li|
      if li.after_subtotal

        if li.billable_party == party
          accum += li.percentage_of_subtotal ? li.revenue_total_with_percentage(sub_total) : li.revenue_total
        end

        if li.payable_party == party
          accum -= li.percentage_of_subtotal ? -li.expense_total_with_percentage(sub_total) : li.expense_total
        end

      else

        if li.billable_party == party
          accum += li.revenue_total
        end

        if li.payable_party == party
          accum -= li.expense_total
        end
        
      end

    end
    accum
  end

  # Sum up the revenue for the post subtotal items
  # ---------------------------------------------------------------------------
  def revenue_after_subtotal_by_party party, invoiced=nil, document_id=nil
    sub_total = revenue_subtotal_by_party(party)
    accum = Money.new(0)

    filter_invoiced(line_items, invoiced, document_id).each do |li|
      if li.after_subtotal

        if li.billable_party == party
          accum += li.percentage_of_subtotal ? li.revenue_total_with_percentage(sub_total) : li.revenue_total
        end

        if li.payable_party == party
          accum -= li.percentage_of_subtotal ? li.expense_total_with_percentage(sub_total) : li.expense_total
        end

      end

    end
    accum
  end

  # Sum up all revenue items
  # ---------------------------------------------------------------------------
  def revenue_total_by_party party, invoiced=nil, document_id=nil
    revenue_subtotal_by_party(party, invoiced, document_id) + revenue_general_tax_by_party(party, invoiced, document_id) + revenue_after_subtotal_by_party(party, invoiced, document_id)
  end


  # Sum up all prepaid libabilities for an event.
  # IE popup vouchers are a prepaid liability
  # ---------------------------------------------------------------------------
  def prepaid_liabilities_total
    voucher_groups.inject(Money.new(0)) { |sum, vg| sum + ( vg.cogs * vg.quantity ) }
  end

  # ---------------------------------------------------------------------------
  # *** Expense
  # ---------------------------------------------------------------------------

  # Expense calculations (using the Revenue calcs)
  # ---------------------------------------------------------------------------
  def expense_subtotal_by_party party, invoiced=nil, document_id=nil
    val = revenue_subtotal_by_party(party, invoiced, document_id)
    if val != 0
      val = -val
    end
    val
  end

  # Sum up the tax being paid on all the items in the subtotals
  # ---------------------------------------------------------------------------
  def expense_general_tax_by_party party, invoiced=nil, document_id=nil
    val = revenue_general_tax_by_party(party, invoiced, document_id)
    if val != 0
      val = -val
    end
    val
  end

  # Sum up the expense for line items of a particular sub_type
  # ---------------------------------------------------------------------------
  def expense_by_party_and_line_item_subtype party, line_item_sub_type, invoiced=nil, document_id=nil
    sub_total = expense_subtotal_by_party(party)
    accum = Money.new(0)

    filter_invoiced(line_items, invoiced, document_id).select{|li| li.line_item_sub_type == line_item_sub_type}.each do |li|
      if li.after_subtotal

        if li.billable_party == party
          accum -= li.percentage_of_subtotal ? li.revenue_total_with_percentage(sub_total) : li.revenue_total
        end

        if li.payable_party == party
          accum += li.percentage_of_subtotal ? li.expense_total_with_percentage(sub_total) : li.expense_total
        end

      else

        if li.billable_party == party
          accum -= li.revenue_total
        end

        if li.payable_party == party
          accum += li.expense_total
        end
        
      end

    end
    accum
  end

  # Sum up the expense for the post subtotal items
  # ---------------------------------------------------------------------------
  def expense_after_subtotal_by_party party, invoiced=nil, document_id=nil
    sub_total = expense_subtotal_by_party(party)
    accum = Money.new(0)

    filter_invoiced(line_items, invoiced, document_id).each do |li|
      if li.after_subtotal

        if li.billable_party == party
          accum -= li.percentage_of_subtotal ? li.revenue_total_with_percentage(sub_total) : li.revenue_total
        end

        if li.payable_party == party
          accum += li.percentage_of_subtotal ? li.expense_total_with_percentage(sub_total) : li.expense_total
        end

      end

    end
    accum
  end

  # Sum up all expense items
  # ---------------------------------------------------------------------------
  def expense_total_by_party party, invoiced=nil, document_id=nil
    expense_subtotal_by_party(party, invoiced, document_id) + expense_general_tax_by_party(party, invoiced, document_id) + expense_after_subtotal_by_party(party, invoiced, document_id)
  end

end