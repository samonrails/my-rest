# == Schema Information
#
# Table name: line_items
#
#  id                              :integer          not null, primary key
#  line_item_type                  :string(255)
#  sku                             :string(255)
#  name                            :string(255)
#  notes                           :text
#  quantity                        :integer
#  include_price_in_expense        :boolean
#  include_price_in_revenue        :boolean
#  event_id                        :integer
#  inventory_item_id               :integer
#  billable_party_type             :string(255)
#  billable_party_id               :integer
#  payable_party_type              :string(255)
#  payable_party_id                :integer
#  tax_rate_expense                :decimal(, )
#  tax_rate_revenue                :decimal(, )
#  line_item_sub_type              :string(255)
#  after_subtotal                  :boolean
#  percentage_of_subtotal          :boolean
#  document_id                     :integer
#  unit_price_expense_cents        :integer
#  unit_price_revenue_cents        :integer
#  parent_id                       :integer
#  menu_template_id                :integer
#  tax_rate_default_locked_expense :boolean          default(FALSE), not null
#  tax_rate_default_locked_revenue :boolean          default(FALSE), not null
#  add_on_parent_id                :integer
#  opposing_line_item_id           :integer
#

class LineItem < ApplicationModel

  belongs_to :event
  belongs_to :document
  belongs_to :inventory_item
  belongs_to :menu_template
  belongs_to :add_on_parent, foreign_key: 'add_on_parent_id', class_name: 'LineItem'
  belongs_to :opposing_line_item, foreign_key: 'opposing_line_item_id', class_name: 'LineItem'
  belongs_to :payable_party, :polymorphic => true
  belongs_to :billable_party, :polymorphic => true
  has_many   :add_ons, foreign_key: 'add_on_parent_id', class_name: 'LineItem'
  has_one    :voucher  
  
  default_scope order 'line_item_type'
  default_scope order 'name'

  validates :unit_price_expense_cents, :numericality => true
  validates :unit_price_revenue_cents, :numericality => true
  validates :event, :presence => true
  validates :unit_price_expense_cents, :presence => true
  validates :unit_price_revenue_cents, :presence => true

  monetize :unit_price_expense_cents
  monetize :unit_price_revenue_cents

  after_initialize :initial_values

  public

    # Display helpers
    # ---------------------------------------------------------------------------

    def sku_display
      string = self.sku
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>#{ao.sku}</font>"}
      string.html_safe
    end

    def name_display
      string = self.name
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>- #{ao.name}</font>"}
      string.html_safe
    end

    def name_display_condensed 
      string = "#{self.name}"
      if self.add_ons.count > 0
        string << "<br><font size='1'> Options: "
        string << self.add_ons_grouped.map{ |k,v| v == 1 ? "#{k}" : "#{k} (#{v}x)"}.join(', ') + "</font>"
      end
      string.html_safe
    end

    def name_with_links_display
      string = "<a class='pointer toggle-modal' data-target='#edit_line_item_form_#{self.id.to_s}'>#{self.name}</a>"
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>- <a class='pointer toggle-modal' data-target='#edit_line_item_form_#{ao.id.to_s}'>#{ao.name}</a></font>"}
      string.html_safe
    end

    def quantity_display
      string = (self.quantity == 0) ? "-" : self.quantity.to_s
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>#{(ao.quantity == 0) ? "-" : ao.quantity}</font>"}
      string.html_safe
    end

    def quantity_display_condensed
      string = (self.quantity == 0) ? "-" : self.quantity.to_s
      string.html_safe
    end

    def unit_price_expense_display negate=false
      mult = negate ? -1 : 1
      string = (self.include_price_in_expense) ? String.new(ActionController::Base.helpers.number_to_currency(self.unit_price_expense * mult)) : '-'
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>#{(ao.include_price_in_expense) ? String.new(ActionController::Base.helpers.number_to_currency(ao.unit_price_expense * mult)) : '-'}</font>"}
      string.html_safe
    end

    def unit_price_expense_display_condensed negate=false
      mult = negate ? -1 : 1
      string = (self.include_price_in_expense) ? String.new(ActionController::Base.helpers.number_to_currency(self.unit_price_expense * mult)) : '-'
      if self.add_ons.count > 0
        total = self.add_ons.inject(Money.new(0)){ |sum, item| sum + (item.include_price_in_expense ? (item.unit_price_expense * mult) : Money.new(0)) }
        total_s = String.new(ActionController::Base.helpers.number_to_currency(total))
        string << "<br><font size='1'>#{total_s}</font>"
      end
      string.html_safe
    end

    def unit_price_revenue_display negate=false
      mult = negate ? -1 : 1
      string = (self.include_price_in_revenue) ? String.new(ActionController::Base.helpers.number_to_currency(self.unit_price_revenue * mult)) : '-'
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>#{(ao.include_price_in_revenue) ? String.new(ActionController::Base.helpers.number_to_currency(ao.unit_price_revenue * mult)) : '-'}</font>"}
      string.html_safe
    end

    def unit_price_revenue_display_condensed negate=false
      mult = negate ? -1 : 1
      string = (self.include_price_in_revenue) ? String.new(ActionController::Base.helpers.number_to_currency(self.unit_price_revenue * mult)) : '-'
      if self.add_ons.count > 0
        total = self.add_ons.inject(Money.new(0)){ |sum, item| sum + (item.unit_price_revenue ? (item.unit_price_revenue * mult) : Money.new(0)) }
        total_s = String.new(ActionController::Base.helpers.number_to_currency(total))
        string << "<br><font size='1'>#{total_s}</font>"
      end
      string.html_safe
    end

    def total_expense_display negate=false
      mult = negate ? -1 : 1
      string = (self.include_price_in_expense) ? String.new(ActionController::Base.helpers.number_to_currency(self.expense_total * mult)) : '-'
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>#{(ao.include_price_in_expense) ? String.new(ActionController::Base.helpers.number_to_currency(ao.expense_total * mult)) : '-'}</font>"}
      string.html_safe
    end

    def total_expense_display_condensed negate=false
      mult = negate ? -1 : 1
      string = (self.include_price_in_expense) ? String.new(ActionController::Base.helpers.number_to_currency(self.expense_total * mult)) : '-'
      if self.add_ons.count > 0
        total = self.add_ons.inject(Money.new(0)){ |sum, item| sum + (item.include_price_in_expense ? (item.expense_total * mult) : Money.new(0)) }
        string << "<br><font size='1'>#{String.new(ActionController::Base.helpers.number_to_currency(total))}</font>"
      end
      string.html_safe
    end

    def total_revenue_display negate=false
      mult = negate ? -1 : 1
      string = (self.include_price_in_revenue) ? String.new(ActionController::Base.helpers.number_to_currency(self.revenue_total * mult)) : '-'
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>#{(ao.include_price_in_revenue) ? String.new(ActionController::Base.helpers.number_to_currency(ao.revenue_total * mult)) : '-'}</font>"}
      string.html_safe
    end

    def total_revenue_display_condensed negate=false
      mult = negate ? -1 : 1
      string = (self.include_price_in_revenue) ? String.new(ActionController::Base.helpers.number_to_currency(self.revenue_total * mult)) : '-'
      if self.add_ons.count > 0
        total = self.add_ons.inject(Money.new(0)){ |sum, item| sum + (item.include_price_in_revenue ? (item.revenue_total * mult) : Money.new(0)) }
        string << "<br><font size='1'>#{String.new(ActionController::Base.helpers.number_to_currency(total))}</font>"
      end
      string.html_safe
    end

    def tax_rate_expense_display
      string = (!self.include_price_in_expense) ? "-" : String.new(ActionController::Base.helpers.number_with_precision(self.expense_tax_rate * 100, precision: 2))
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>#{(!ao.include_price_in_expense) ? "-" : String.new(ActionController::Base.helpers.number_with_precision(ao.expense_tax_rate * 100, precision: 2))}</font>"}
      string.html_safe
    end

    def tax_rate_revenue_display
      string = (!self.include_price_in_revenue) ? "-" : String.new(ActionController::Base.helpers.number_with_precision(self.revenue_tax_rate * 100, precision: 2))
      self.add_ons_sorted.each { |ao| string << "<br><font size='1'>#{(!ao.include_price_in_revenue) ? "-" : String.new(ActionController::Base.helpers.number_with_precision(ao.revenue_tax_rate * 100, precision: 2))}</font>"}
      string.html_safe
    end

    def add_ons_sorted
      included = self.add_ons.select{|ao| ao.name.include?("included")}
      included + (self.add_ons - included)
    end

    def add_ons_grouped
      ii_count = {}
      self.add_ons.each do |item| 
        name = item.name.chomp(" (included)")
        ii_count[name] = ii_count[name].nil? ? item.quantity : ii_count[name] + item.quantity
      end
      ii_count
    end

    def pretty_id
      "#{self.id.to_s.rjust(7, "0")}"
    end

    # Add-ons
    # ---------------------------------------------------------------------------

    # Only to be called on a Vendor line item
    def process_add_ons inventory_item_to_quantity

      # If no opposing line item, try to set one.
      if self.opposing_line_item.nil?
        possible_opposing_line_items = self.event.line_items.select{|li| !li.billable_party.nil? && (li.inventory_item_id == self.inventory_item_id)}
        if possible_opposing_line_items.count > 0
          self.opposing_line_item_id = possible_opposing_line_items.first.id
          self.save
        end
      end

      items_to_delete = self.add_ons.select{|li| !li.inventory_item_id.nil?}
      if items_to_delete.count > 0
        self.event.destroy_line_items(items_to_delete)
        self.add_ons.delete(items_to_delete)
      end

      if !self.opposing_line_item.nil?
        opposing_items_to_delete = self.opposing_line_item.add_ons.select{|li| !li.inventory_item_id.nil?}
        if opposing_items_to_delete.count > 0
          self.opposing_line_item.event.destroy_line_items(opposing_items_to_delete)
          self.opposing_line_item.add_ons.delete(opposing_items_to_delete)
        end
      end

      inventory_item_to_quantity.each do |inventory_item_id_string, quantity_string|

        # Convert inputs variables to ints
        inventory_item_id = inventory_item_id_string.to_i
        quantity = quantity_string.to_i

        if quantity > 0
          # We want this add-on
          new_line_items = self.event.create_line_item_from_inventory_item_id(inventory_item_id, quantity, true, true, "")
          self.add_ons.push(new_line_items[0])
          self.opposing_line_item.add_ons.push(new_line_items[1]) if !self.opposing_line_item.nil?
        end
      end

      # We have all the line items now.  Loop the groups.
      inventory_item.option_groups.each do |og|

        # Sort the inventory items in the group by price
        sorted_inventory_item_ids = og.inventory_items.sort_by{|i| i.cogs_cents - i.premium_price_cents}.map{|i| i.id}.flatten

        # Determine which line items are in this group
        group_line_items = self.add_ons.select{|li| sorted_inventory_item_ids.include?(li.inventory_item_id)}

        # Sort the line items
        group_line_items = group_line_items.sort_by{|li| sorted_inventory_item_ids.index(li.inventory_item_id)}

        included_count = 0
        index = 0
        while included_count < [og.included, group_line_items.count].min do

          included_count += group_line_items[index].quantity
          if included_count > og.included

            # Create a new line item for the "full price" remainder
            new_line_items = self.event.create_line_item_from_inventory_item_id(group_line_items[index].inventory_item.id, included_count - og.included, true, true, "")
            self.add_ons.push(new_line_items[0])
            self.opposing_line_item.add_ons.push(new_line_items[1])

            # Alter the line item for the "included" price, and reduce the quantity
            group_line_items[index].unit_price_expense = InventoryItem.find(group_line_items[index].inventory_item).premium_price
            group_line_items[index].quantity -= (included_count - og.included)
            group_line_items[index].name += " (included)"
            group_line_items[index].save

            group_line_items[index].opposing_line_item.unit_price_revenue = self.event.calculate_sell_price_using_account_pricing_tier(group_line_items[index].unit_price_expense)
            group_line_items[index].opposing_line_item.quantity -= (included_count - og.included)
            group_line_items[index].opposing_line_item.name += " (included)"
            group_line_items[index].opposing_line_item.save
          else
            # Alter the line item for the "included" price
            group_line_items[index].unit_price_expense = InventoryItem.find(group_line_items[index].inventory_item).premium_price
            group_line_items[index].name += " (included)"
            group_line_items[index].save

            group_line_items[index].opposing_line_item.unit_price_revenue = self.event.calculate_sell_price_using_account_pricing_tier(group_line_items[index].unit_price_expense)
            group_line_items[index].opposing_line_item.name += " (included)"
            group_line_items[index].opposing_line_item.save
          end

          index += 1
        end

      end
    end

    def required_options_satisfied
      if self.inventory_item_id.nil?
        true
      else
        satisfied = true
        self.inventory_item.option_groups.each do |og|
          inventory_item_ids = og.inventory_items.map{|i| i.id}.flatten
          group_qty_sum = self.add_ons.select{|li| inventory_item_ids.include?(li.inventory_item_id)}.inject(0) { |sum, li| sum + li.quantity }
          if group_qty_sum < og.required
            satisfied = false
          end
        end
        satisfied
      end
    end

    # Taxes
    # ---------------------------------------------------------------------------

    def default_tax_rate
      if defined?(self.billable_party.tax_exempt) && self.billable_party.tax_exempt
        0
      else
        case Product.find_parent(event.product)

          when ProductType.managed_services || ProductType.select
            if defined? event.location.building.market.default_tax_rate
              event.location.building.market.default_tax_rate
            else
              0
            end
          when ProductType.perks
            if defined? inventory_item.vendor.default_tax_rate
              inventory_item.vendor.default_tax_rate
            elsif defined? menu_template.vendor.default_tax_rate
              menu_template.vendor.default_tax_rate
            else
              0
            end
          else
            0
          end
        end
    end

    def lock_tax_rate
      something_changed = false

      if self.payable_party && self.tax_rate_expense.nil?
        self.tax_rate_expense = self.default_tax_rate
        self.tax_rate_default_locked_expense = true
        something_changed = true
      end

      if self.billable_party && self.tax_rate_revenue.nil?
        self.tax_rate_revenue = self.default_tax_rate
        self.tax_rate_default_locked_revenue = true
        something_changed = true
      end

      self.save if something_changed

    end
    
    # Financials helpers
    # ---------------------------------------------------------------------------
    def revenue_total
      if self.add_on_parent
        
        vendor = nil
        vendor = self.inventory_item.vendor if self.inventory_item
        vendor = self.menu_template.vendor if self.menu_template

        qty_mult = 1
        if self.add_on_parent.quantity != 0
          qty_mult = self.add_on_parent.quantity
        elsif vendor != nil
          qty_mult = self.event.per_person_quantity_for_billable_and_payable_party(self.billable_party, vendor)
        end
        
        include_price_in_revenue ? unit_price_revenue * quantity * qty_mult : Money.new(0)
      else
        include_price_in_revenue ? unit_price_revenue * quantity : Money.new(0)
      end
      
    end

    def expense_total
      if self.add_on_parent
        qty_mult = self.add_on_parent.quantity == 0 ? self.event.per_person_quantity_for_payable_party(self.payable_party) : self.add_on_parent.quantity
        include_price_in_expense ? unit_price_expense * quantity * qty_mult : Money.new(0)
      else
        include_price_in_expense ? unit_price_expense * quantity : Money.new(0)
      end
    end

    def revenue_tax_rate
      (tax_rate_revenue.nil? ? default_tax_rate : tax_rate_revenue)/100
    end

    def expense_tax_rate
      (tax_rate_expense.nil? ? default_tax_rate : tax_rate_expense)/100
    end

    def revenue_tax_unrounded
      revenue_total.dollars * revenue_tax_rate
    end

    def expense_tax_unrounded
      expense_total.dollars * expense_tax_rate
    end

    def revenue_tax
      revenue_total * revenue_tax_rate
    end

    def expense_tax
      expense_total * expense_tax_rate
    end

    def revenue_total_with_percentage subtotal
      subtotal * unit_price_revenue.to_s.to_f/100
    end

    def expense_total_with_percentage subtotal
      subtotal * unit_price_expense.to_s.to_f/100
    end

    # Filtering helpers
    # ---------------------------------------------------------------------------

    def per_person_price_for_vendor vendor
      (line_item_sub_type == "Menu-Fee") && ((!menu_template.nil? && menu_template.vendor_id == vendor.id) || (payable_party == vendor))
    end

    def menu_item_for_vendor vendor
       (line_item_sub_type == "Menu-Item") && ((!inventory_item.nil? && inventory_item.vendor_id == vendor.id) || (payable_party == vendor))
    end

    # This next case shouldn't happen, but we'll put something in for it just in case
    def menu_with_no_vendor
      (line_item_sub_type == "Menu-Fee" && menu_template.nil? && payable_party.nil?) || (line_item_sub_type == "Menu-Item" &&  inventory_item.nil? && payable_party.nil?)
    end

    def menu
      (line_item_sub_type == "Menu-Fee" || line_item_sub_type == "Menu-Item")
    end

    def associated_with_vendor
      menu && !menu_with_no_vendor
    end
    
    def pretty_quantity
      (self.quantity == 0)  ? "-" : self.quantity
    end

    def reset_default_tax_rates
      self.tax_rate_expense = nil if self.tax_rate_expense != 0
      self.tax_rate_revenue = nil if self.tax_rate_revenue != 0
      self.tax_rate_default_locked_expense = false
      self.tax_rate_default_locked_revenue = false
    end

    def delete_opposing_line_item
      # These are opposing_line_item_id which links to the table and will cause an error
      # if one just tries to delete them straight off (foreign key errors). Therefore, 
      # we must go through each one, set the  opposing_line_item_id to NULL before deleting the record. 
      if !self.opposing_line_item_id.nil?

       self.opposing_line_item.add_ons.all.each do |x| 
        opposing_line_item_to_delete = LineItem.where(:opposing_line_item_id =>  x.id).first
        if opposing_line_item_to_delete
          opposing_line_item_to_delete.opposing_line_item_id = nil
          opposing_line_item_to_delete.save

          # Set the current line item we are looking at to have a null opposing_line_item
          x.opposing_line_item_id = nil
          x.save

          # Delete the opposing line item
          opposing_line_item_to_delete.destroy
        end
       end  
       
       self.opposing_line_item.add_ons.destroy(self.opposing_line_item.add_ons.all)
       self.opposing_line_item.destroy
 
      elsif !self.inventory_item_id.nil?
        # This needs to be done because the concept of the "opposing line item" is rather new.
        self.event.delete_all_line_items_for_inventory_item_id(self.inventory_item_id)
      end
    end
    
  private

    def initial_values
      self.quantity ||= 0
      self.after_subtotal  ||= false
      self.percentage_of_subtotal  ||= false
      self.unit_price_expense_cents  ||= 0
      self.unit_price_revenue_cents  ||= 0
      self.name ||= ""
      self.notes ||= ""
      self.quantity ||= 0
    end


end