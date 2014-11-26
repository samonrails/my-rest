# == Schema Information
#
# Table name: events
#
#  id                               :integer          not null, primary key
#  name                             :string(255)
#  meal_period                      :string(255)
#  account_id                       :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  quantity                         :integer
#  product                          :string(30)
#  menu_name                        :string(255)
#  status                           :string(255)
#  contact_id                       :integer
#  service_style                    :string(255)
#  individual_label                 :boolean
#  utensils_plates_napkins          :boolean
#  serving_utensils                 :boolean
#  sternos                          :boolean
#  chaffing_frames                  :boolean
#  internal_event_notes             :text
#  external_account_notes           :text
#  building_instructions            :text
#  location_instructions            :text
#  location_id                      :integer
#  event_transaction_method_id      :integer
#  event_start_time                 :datetime
#  event_end_time                   :datetime
#  setup_start_time                 :datetime
#  setup_end_time                   :datetime
#  created_by_id                    :integer
#  event_start_time_utc             :datetime
#  event_end_time_utc               :datetime
#  setup_start_time_utc             :datetime
#  setup_end_time_utc               :datetime
#  event_managed_services_rollup_id :integer
#  cancellation_reason              :string(255)
#  canceled_within_24_hours         :boolean          default(FALSE), not null
#  event_schedule_id                :integer
#  duplicated_from_event_id         :integer
#  feedback_status                  :string(255)
#  feedback_updated_at              :datetime
#  event_owner_id                   :integer
#  claimed_at                       :datetime
#

class Event < ApplicationModel

  # From "Craig's Admin"
  include SearchSortPaginate
  include Fooda::Search
  include Event::CateringFinancials
  include Event::LineItems
  include Event::FinancialsRollup
  include Event::RateEvent
  include Event::PaymentTransaction

  searchkick
  
  global_site_search :on => [:name, :menu_name, :"id::varchar(255)"]

  belongs_to :account
  belongs_to :contact
  belongs_to :location
  belongs_to :event_managed_services_rollup
  belongs_to :event_schedule

  # Billing/Payment for account
  belongs_to :event_transaction_method, :dependent => :destroy

  has_many :notes
  has_many :issues, as: :subject
  has_many :line_items, :dependent => :restrict
  has_many :event_vendors, :dependent => :destroy
  has_many :documents, :dependent => :restrict
  has_many :billing_references, :dependent => :destroy
  has_many :vendors, :through => :event_vendors, :dependent => :restrict
  has_many :tokens, :as => :identity, :dependent => :destroy
  has_many :event_ratings, :dependent => :restrict, foreign_key: 'reviewable_id', class_name: 'Review'
  has_many :event_reviews, :dependent => :restrict, foreign_key: 'event_id', class_name: 'Review'
  has_many :event_transactions
  has_many :payment_histories
  has_many :voucher_groups, :dependent => :restrict
  has_many :vouchers, :through => :voucher_groups
  has_one :order, class_name: 'Catering::Order', :dependent => :nullify
  
  belongs_to :created_by, :class_name => "User"
  belongs_to :event_owner, :class_name => "User"

  validates_presence_of :account, :event_start_time
  validates_presence_of :location, :if => :non_financial_product?

  after_initialize :initial_values
  before_validation :possible_status_transaction
  before_create :update_site_notes
  before_save :update_utc_dates
  before_update :account_participation_change
  after_update :check_for_complete_event, :check_for_feedback_status, :check_for_claim

  DATETIME = "%A, %m/%d/%Y at %I:%M%p"
  TIME = "%I:%M%p"

  accepts_nested_attributes_for :event_vendors
  accepts_nested_attributes_for :event_reviews
  accepts_nested_attributes_for :event_ratings, reject_if: proc {|attributes| attributes['rating'].blank?}

  scope :unclaimed_events, lambda{ where(event_owner_id: nil, status: %w{auto_generated proposed scheduled active in_progress})}
  scope :opened, lambda { where(status: %w{proposed scheduled active in_progress}) }
  scope :completed, lambda { where(status: %w{complete final})}
  scope :canceled, lambda { where(status: %w{canceled})}


  def uninvoiced_voucher_groups
    self.voucher_groups.select { |v| v.document_id.nil?}
  end

  # ---------------------------------------------------------------------------
  # Searching
  # ---------------------------------------------------------------------------
  
  
  def search_data
    {
      id: id,
      account_id: account_id,
      account_names: account.try(:name).try(:downcase),
      meal_period: meal_period.try(:downcase),
      vendor_names: vendors.map{|v| v.name.downcase},
      vendor_id: vendors.map(&:id),
      event_start_time: event_start_time,
      event_end_time: event_end_time,
      status: status.downcase,
      product: product.downcase,
      markets: try(:location).try(:building).try(:market).try(:name).try(:downcase),
      account_executive: created_by.try(:email).try(:downcase),
      created_at: created_at
    }
  end

  def to_search_result
    super.merge(:preview => "Event: " + self.pretty_id)
  end


  def self.default_search_fields parent_model=nil
    [
      { :name => :event_start_time, :as => :datetimerange },
    ]
  end

  def self.all_possible_search_fields parent_model=nil
    [
      { :name => :event_start_time, :as => :datetimerange }, 
      { :name => :account, :as => :string, :wildcard => :both },
      { :name => :vendor, :as => :string, :wildcard => :both },
      { :name => :event_start_time, :as => :datetimerange }, 
      { :name => :product, :as => :multi_select },
      { :name => :status, :as => :multi_select },
      { :name => :meal_period, :as => :multi_select },
      { :name => :market, :as => :multi_select },
      { :name => :account_executive, :as => :select },
    ]
  end

  def to_s
    (self.name.nil? || self.name.empty?) ? "Event: " + self.pretty_id : self.name
  end

  def initial_values
    self.status ||= Status::Event.proposed
    self.event_transaction_method  ||= EventTransactionMethod.new if self.new_record?
    self.quantity ||= 0
    self.location_instructions ||= ""
    self.building_instructions ||= ""
  end

  def duplicate current_user_id, params={}
    new_event = self.dup
    new_event.event_start_time = params[:event_start_time]
    new_event.event_end_time = params[:event_end_time]
    new_event.setup_start_time = params[:setup_start_time]
    new_event.setup_end_time = params[:setup_end_time]
    new_event.quantity = params[:quantity]
    new_event.meal_period = params[:meal_period]
    new_event.name = params[:name]
    new_event.event_owner_id = params[:event_owner_id]
    new_event.status = Status::Event.scheduled
    new_event.cancellation_reason = ""
    new_event.canceled_within_24_hours = false
    new_event.event_transaction_method = EventTransactionMethod.new
    new_event.event_managed_services_rollup_id = nil
    new_event.created_by_id = current_user_id
    new_event.duplicated_from_event_id = self.id
    new_event.feedback_status = nil
    new_event.feedback_updated_at = nil
    new_event.event_owner_id = nil
    new_event.claimed_at
    
    # Duplicate the Event Vendors
    self.event_vendors.each do |ev|
      ev_new = ev.dup
      ev_new.event = new_event
      ev_new.event_transaction_method = EventTransactionMethod.new
      ev_new.vendor_billing_summary_sent_at = nil
      ev_new.save
      new_event.event_vendors.push ev_new
    end

    # Duplicate the Line Items
    orig_to_dup = {}
    self.line_items.where(:parent_id => nil, :add_on_parent_id => nil).each do |li_orig|
      li = li_orig.dup
      li.reset_default_tax_rates
      li.document_id = nil
      li.quantity = new_event.quantity if li.line_item_sub_type == "Menu-Fee"
      new_event.line_items.push li

      # Map the IDs
      orig_to_dup[li_orig.id] = li.id

      li_orig.add_ons.each do |addon_orig|

        # Duplicate the add on line item
        addon = addon_orig.dup
        addon.reset_default_tax_rates
        addon.document_id = nil
        new_event.line_items.push addon
        li.add_ons.push addon

        # Map the IDs
        orig_to_dup[addon_orig.id] = addon.id
      end
    end

    # Set the correct opposing line item IDs
    new_event.line_items.each do |li|
      li.opposing_line_item_id = orig_to_dup[li.opposing_line_item_id] if !li.opposing_line_item_id.nil?
      li.save
    end

    # Duplicate the Billing References
    self.billing_references.each do |br|
      br_copy = br.dup
      br_copy.tag_list.add(br.tag_list)
      new_event.billing_references.push(br_copy)
    end

    new_event.save
    # Perform initial rollup
    new_event.trigger_event_rollup
    new_event.update_transaction_method
    new_event
  end

  def non_financial_product?
    Product.non_financial_values.include?(self.product)
  end

  def check_for_complete_event
    if self.status_changed? && self.status == Status::Event.complete
      lock_line_items_tax_rate
    end
  end

  def check_for_feedback_status
    if self.feedback_status_changed?
      self.touch :feedback_updated_at
    end
  end

  def check_for_claim
    if event_owner_id_changed? && event_owner_id_was.nil?
      building = location.building
      unless building.is_approved?
        building_market_name = building.market ? building.market.try(:name) : "-"
        building_url = Rails.application.routes.url_helpers.edit_admin_building_url(building, host: ActionMailer::Base.default_url_options[:host])
        issues.create(title: 'Event Claimed with unverified address', 
                      description: "Event ID #{pretty_id} has an unapproved building. As event owner, you are responsible for reviewing the new building associated to this event. Buildling approval is required before the event can proceed to scheduled status.<br><br>Event:<br>#{building.try(:html_address)}<br><br>Market: #{building_market_name}<br><br>Unclaimed Building: <a href='#{building_url}'>Snappea Building Page</a><br><br>-SnapPea", 
                      priority: 'High', due_date: Date.today.next_business_day.to_datetime, assignee_id: event_owner_id, assigner_id: event_owner_id)
      end
    end
  end

  def possible_status_transaction
    if status_change == %w{scheduled active}
      errors.add(:status, "can't be changed to Active because of unapproved building") unless location.building.is_approved?
    end
  end

  def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end

  def financial_product?
    Product.financial_values.include?(self.product)
  end

  def pretty_event_datetime
    return self.event_start_time.strftime(DATETIME) if self.event_end_time.nil?

    start_format = self.event_start_time.to_date == self.event_end_time.to_date ? TIME : DATETIME
    end_datetime = ' - ' + self.event_end_time.strftime( start_format )
    return self.event_start_time.strftime(DATETIME) << end_datetime.to_s
  end

  def pretty_setup_datetime
    unless self.setup_start_time.nil?
      return self.setup_start_time.strftime(DATETIME) if self.setup_end_time.nil?

      start_format = self.setup_start_time.to_date == self.setup_end_time.to_date ? TIME : DATETIME
      end_datetime = ' - ' + self.setup_end_time.strftime( start_format )
      return self.setup_start_time.strftime(DATETIME) << end_datetime.to_s
    end
    ""
  end

  def local_with_no_timezone_to_utc val
    if location and location.building and location.building.timezone
      ActiveSupport::TimeZone[location.building.timezone].parse(val.strftime("%d %B %Y %l:%M %p")).utc
    else
      val
    end
  end

  def utc_to_local_with_no_timezone val
    if location and location.building and location.building.timezone
      DateTime.parse(val.in_time_zone(location.building.timezone).strftime("%d %B %Y %l:%M %p"))
    else 
      val
    end
  end

  def pretty_vendors
    self.event_vendors.map {|v| v.vendor.name}.join(", ")
  end

  def update_site_notes
    return if self.location.nil?

    ["service_event_instructions", "connectivity_instructions", "delivery_event_instructions"].each do |note_name|
      note = self.location.send(note_name)
      unless note.empty?
        self.location_instructions += "#{note_name.titleize}:\n------------------------------------------\n#{note}\n\n"
      end
    end

    unless self.location.building.nil?
      ["loading_information", "parking_information", "site_directions"].each do |note_name|
        note = self.location.building.send(note_name)
        unless note.empty?
          self.building_instructions += "#{note_name.titleize}:\n------------------------------------------\n#{note}\n\n"
        end
      end
    end
  end

  def update_utc_dates

    self.event_start_time_utc = local_with_no_timezone_to_utc(event_start_time) unless event_start_time.nil?
    self.event_end_time_utc = local_with_no_timezone_to_utc(event_end_time) unless event_end_time.nil?
    self.setup_start_time_utc = local_with_no_timezone_to_utc(setup_start_time) unless setup_start_time.nil?
    self.setup_end_time_utc = local_with_no_timezone_to_utc(setup_end_time) unless setup_end_time.nil?
  end

  def trigger_event_rollup
    begin
      Sidekiq::Client.enqueue(ManagedServicesRollup, self.id)
    rescue Exception => e
      Rails.logger.info "**** WARNING: Not able to access Sidekiq, rolling up Event financials synchronously"
      do_managed_services_rollup
    end
  end

  def do_managed_services_rollup

    Rails.logger.info "**** do_managed_services_rollup - Event ID: " + id.to_s

    if Product.find_parent(self.product) == ProductType.managed_services
      self.event_managed_services_rollup ||= EventManagedServicesRollup.new

      self.event_managed_services_rollup.update_attributes!(:revenue => self.catering_revenue, 
        :cogs => self.catering_cogs, :delivery_charge_to_vendor => self.catering_delivery_charge_to_vendor, 
        :delivery_charge_to_account => self.catering_delivery_charge_to_account, 
        :total_billing => self.catering_total_billing, :total_tax => self.catering_total_tax, 
        :subtotal => self.catering_subtotal, :gratuity => self.catering_gratuity, :enterprise_fee => self.catering_enterprise_fee,
        :vouchers_purchased => self.catering_voucher_purchased_amount)
      self.save
    end
  end

  def reload_site_notes
    self.building_instructions = ""
    self.location_instructions = ""
    self.update_site_notes
    self.save
  end

  def account_participation_change
    if self.quantity_changed?
      self.line_items.select{|li| (li.billable_party == self.account || li.payable_party == self.account) && li.line_item_sub_type == "Menu-Fee"}.each do |li|
        li.quantity = self.quantity
        li.save
      end
    end
  end

  def vendor_participation_change event_vendor
    if event_vendor.participation_changed?
      self.line_items.select{|li| (li.billable_party == event_vendor.vendor || li.payable_party == event_vendor.vendor) && li.line_item_sub_type == "Menu-Fee"}.each do |li|
        li.quantity = event_vendor.participation
        li.save
      end
    end
  end

  def event_ratings
    super.select{|r| r.reviewable_type == "Event"}
  end

  def update_transaction_method
    self.event_transaction_method.update_attributes(transaction_method: "on_account", party_type: Account.name, party_id: self.account_id) if self.account.credit_status.titleize == "On Account"
  end

  public

    def required_options_satisfied
      self.line_items.select{|li| !li.required_options_satisfied}.count == 0
    end

    def create_per_person_charge_addons_for_payable_party party

      line_items_no_price_menu_items_by_payable_party(party).each do |li|

        items_to_delete = li.add_ons.select{|li2| !li2.menu_template_id.nil?}
        if items_to_delete.count > 0
          li.event.destroy_line_items(items_to_delete)
          li.add_ons.delete(items_to_delete)
        end

        opposing_items_to_delete = li.opposing_line_item.add_ons.select{|li2| !li2.menu_template_id.nil?}
        if opposing_items_to_delete.count > 0
          li.opposing_line_item.event.destroy_line_items(opposing_items_to_delete)
          li.opposing_line_item.add_ons.delete(opposing_items_to_delete)
        end

        if !li.inventory_item_id.nil? && li.inventory_item.premium_price != 0
          new_line_items = create_line_item_premium_per_person_charge(li.inventory_item)
          li.add_ons.push(new_line_items[0])
          li.opposing_line_item.add_ons.push(new_line_items[1])
        end
      end
    end

    def per_person_charge_for_payable_party party
      lis = line_items.select{|li| li.payable_party == party && li.line_item_sub_type == "Menu-Fee" && li.add_on_parent_id.nil?}
      lis.count > 0 ? lis.first : nil
    end

    def per_person_charge_for_billable_and_payable_party billable_party, payable_party
      lis = line_items.select{|li| li.billable_party == billable_party && li.line_item_sub_type == "Menu-Fee" && li.add_on_parent_id.nil? && 
        ((!li.menu_template.nil? && li.menu_template.vendor == payable_party) || (li.payable_party == payable_party))}
      lis.count > 0 ? lis.first : nil
    end

    def per_person_quantity_for_payable_party party
      li = per_person_charge_for_payable_party(party)
      li.nil? ? 1 : li.quantity
    end

    def per_person_quantity_for_billable_and_payable_party billable_party, payable_party
      li = per_person_charge_for_billable_and_payable_party(billable_party, payable_party)
      li.nil? ? 1 : li.quantity
    end

    # Params doc_type, party_type, party
    def generate_document options={}

      # which vendor or which account?
      party = options["party_type"].constantize.find_by_id(options["party"])

      # generate pending document_entity (the row in the document table)
      document = Document.create( document_type: options["doc_type"],
                                  recipient:     party.name,
                                  total:         "0",
                                  event_id:      self.id,
                                  status:        DocumentStatus::requested,
                                  name:          DocumentStatus::requested,
                                  creator_id:    options["current_user"])
      options["document_id"] = document.id

      #if we're invoicing, lock invoicable line items
      if options["doc_type"] == DocumentType::Event::invoice
        lock_new_invoice_line_items party, document
      end
      # queue the pdf creation and persistence
      Sidekiq::Client.enqueue( EventDocument, options )
    end

    # Entry point for adding an ad-hoc line item from an inventory item
    # ---------------------------------------------------------------------------
    def create_line_item_from_inventory_item_id inventory_item_id, qty, include_price_in_expense, include_price_in_revenue, notes
      # Inventory item
      inventory_item = InventoryItem.find(inventory_item_id)
      new_line_items = create_line_item_from_inventory_item(
        inventory_item, qty,
        inventory_item.vendor, account,
        include_price_in_expense, include_price_in_revenue, notes)
      line_items.push(new_line_items)
      new_line_items
    end

    # Entry point for adding a per-person charge
    # ---------------------------------------------------------------------------

    def create_line_item_for_per_person_charge qty, vendor_id, notes
      event_vendor = event_vendors.where(:vendor_id => vendor_id).first
      new_line_items = create_line_item_for_per_person_charge_2(event_vendor.participation, event_vendor, true, true, "")
      line_items.push(new_line_items)
      new_line_items
    end

    def create_line_item_premium_per_person_charge inventory_item
      event_vendor = event_vendors.where(:vendor_id => inventory_item.vendor.id).first
      new_line_items = create_line_item_premium_per_person_charge_2(event_vendor, inventory_item)
      line_items.push(new_line_items)
      new_line_items
    end

    # Entry point for passing in a new menu template
    # ---------------------------------------------------------------------------
    def add_replace_menu_template menu_template_id, participation

      # Fetch new menu template
      new_menu_template = MenuTemplate.find(menu_template_id)

      # Fetch current event_vendor
      ev = fetch_event_vendor_by_vendor_id(new_menu_template.vendor_id)

      if !ev.nil? && ev.menu_template_id == new_menu_template.id
        # Existing vendor, no new menu template.  Just update attributes.
        ev.update_attributes!(:participation => participation)
      else
        if !ev.nil?
          # Existing vendor, new menu template.  Clean out line items, and update attributes from new template.
          remove_all_menu_type_line_items(new_menu_template.vendor.id)
          ev.update_attributes!(:menu_template => new_menu_template, :participation => participation,
            :default_menu_cogs => new_menu_template.cogs, :default_menu_retail_price => new_menu_template.retail_price,
            :default_menu_sell_price => calculate_sell_price_using_account_pricing_tier(new_menu_template.cogs),
            :pricing_type => new_menu_template.pricing_type)
        else
          # New vendor.  Create a new container object.
          ev = event_vendors.create!(
            :vendor => Vendor.find(new_menu_template.vendor.id), :menu_template => new_menu_template, :participation => participation,
            :default_menu_cogs => new_menu_template.cogs, :default_menu_retail_price => new_menu_template.retail_price,
            :default_menu_sell_price => calculate_sell_price_using_account_pricing_tier(new_menu_template.cogs),
            :pricing_type => new_menu_template.pricing_type)
        end

          # Fill in the new container object for this vendor
          process_event_vendor(ev)
          self.save
      end

      create_per_person_charge_addons_for_payable_party(ev.vendor)
      trigger_event_rollup

    end

    # Entry point for choosing new line items from a template.  This will most
    # likely be due to changing the configuration of a grouped template
    # ---------------------------------------------------------------------------
    def change_inventory_items_for_event_vendor vendor_id, inventory_item_ids, include_expense_price, include_revenue_price, inventory_item_quantities={}, item_notes={}, menu_template=nil
      # Remove all menu items where we are dealing with this vendor, but leave the fee, if any
      destroy_line_items(line_items.select{|li| (!li.inventory_item.nil? && li.inventory_item.vendor_id == vendor_id )}) unless menu_template
      inventory_item_ids.each do |id|
        if inventory_item_quantities.is_a? Hash
          # This is how catering does quantity 
          quantity = inventory_item_quantities[id].try(:to_i) || 0
        else
          # This is how snappea's data looks. fuck... -djb
          quantity = inventory_item_quantities[id.to_i].try(:to_i) || 0
        end
        line_items.push(create_line_item_from_inventory_item(InventoryItem.find(id), quantity, Vendor.find(vendor_id), account, include_expense_price.include?(id.to_s), include_revenue_price.include?(id.to_s), item_notes[id]))
      end

      create_per_person_charge_addons_for_payable_party(Vendor.find(vendor_id))
      trigger_event_rollup
    end

    def change_inventory_items_with_quantities_for_event_vendor vendor_id, inventory_item_to_quantity, include_expense_price, include_revenue_price

      # Remove all menu items where we are dealing with this vendor, but leave the fee, if any
      destroy_line_items(line_items.select{|li| (!li.inventory_item.nil? && li.inventory_item.vendor_id == vendor_id)})

      inventory_item_to_quantity.each do |inventory_item_id_string, quantity_string|

        # Convert inputs variables to ints
        inventory_item_id = inventory_item_id_string.to_i
        quantity = quantity_string.to_i

        line_items.push(create_line_item_from_inventory_item(InventoryItem.find(inventory_item_id), quantity, Vendor.find(vendor_id), account, include_expense_price.include?(inventory_item_id.to_s), include_revenue_price.include?(inventory_item_id.to_s), "")) if quantity > 0
      end

      trigger_event_rollup
    end

    # When a menu item is deleted, all line items associated with it need to be deleted
    # ---------------------------------------------------------------------------
    def delete_all_line_items_for_inventory_item_id inventory_item_id
      destroy_line_items(line_items.select{|li| (!li.inventory_item.nil? && li.inventory_item.id == inventory_item_id)})
    end

    # Remove all information for this vendor
    # ---------------------------------------------------------------------------
    def remove_info_for_vendor vendor_id

      # Remove all container objects for this vendor.  There should really never be more
      # than one.
      event_vendors_to_delete = event_vendors.find_all{|item| item.vendor_id == vendor_id }
      event_vendors.destroy(event_vendors_to_delete)

      # Remove all goods-related menu items where we are dealing with this vendor
      destroy_line_items(line_items.where(:payable_party_id => vendor_id, :payable_party_type => 'Vendor'))
      destroy_line_items(line_items.where(:billable_party_id => vendor_id, :billable_party_type => 'Vendor'))
      destroy_line_items(line_items.select{|li| (!li.inventory_item.nil? && li.inventory_item.vendor_id == vendor_id)})
      destroy_line_items(line_items.select{|li| (!li.menu_template.nil? && li.menu_template.vendor_id == vendor_id)})

      trigger_event_rollup
    end

    # Entry point for dynamically-created menu_level_discounts
    # ---------------------------------------------------------------------------
    def set_menu_level_discount_sell_price menu_level_discount
      menu_level_discount.sell_price = calculate_sell_price_using_account_pricing_tier(menu_level_discount.cogs)
    end

    # Given COGS, calculate the sell price using the account's pricing tiers
    # ---------------------------------------------------------------------------
    def calculate_sell_price_using_account_pricing_tier cogs
      if cogs.nil?
        nil
      else
        account_pricing_tier = AccountPricingTier.where(:account_id => account, :product => product).first()

        if account_pricing_tier.nil?
          # Assume GP of 25% if no pricing tier exists
          sell_price = cogs / (1 - 25.0 / 100)
        else
          pricing_tier = PricingTier.find(account_pricing_tier.pricing_tier_id)
          sell_price = cogs / (1 - pricing_tier.gross_profit / 100)
        end
        sell_price
      end
    end

    def self.calculate_sell_price_using_standard_pricing_tier cogs
      pricingTier = PricingTier.where(name: "Standard").first
      sell_price = cogs / (1 - pricingTier.gross_profit / 100.0)
    end

    def self.calculate_buy_price_using_standard_pricing_tier sell_price
      pricingTier = PricingTier.where(name: "Standard").first
      buy_price = sell_price * (1 - pricingTier.gross_profit / 100.0)
    end

    # Email Report Queries
    # --------------------------------------
    def self.end_of_day_sales_report
      last_midnight = Date.today.midnight
      now = DateTime.now.utc
      Event.where(product: ProductType.find_products_by_type(ProductType.managed_services)).where(created_at: last_midnight..now)
    end

    def self.catering_schedule_preview
      midnight = Date.tomorrow.midnight
      # On Friday (midnight on saturday) show events for the weekend and Monday.
      next_midnight = midnight.saturday? ? midnight + 3.days : midnight + 1.day
      Event.where(product: ProductType.find_products_by_type(ProductType.managed_services)).where(event_start_time: midnight..next_midnight).where(status: [Status::Event.proposed, Status::Event.scheduled, Status::Event.active])
    end

    def self.vendors_with_completed_events_in_past_7days date
      search_string = "event_start_time >= '" + (date-7).to_s + "' AND event_start_time < '" + date.to_s + "' AND status = 'complete'";
      Rails.logger.warn "VendorBillingSummaries - Vendor search string: " + search_string 

      events = Event.where([search_string])
      events.map{|e| e.event_vendors}.flatten.select{|ev| ev.vendor_billing_summary_sent_at == nil}.group_by{|ev| ev.vendor_id}
    end
    
    # We need to lock invoice-able items, so they don't get invoiced twice.
    def lock_new_invoice_line_items party, document
      # Generate fixed-price post sub total line items from percentage based sub total line items
      subtotal = revenue_subtotal_by_party(party, false)
      line_items_after_subtotal_percentage_by_billable_party(party).each do |li|
        fixed_price = li.revenue_total_with_percentage subtotal
        line_items.create!(li.attributes.merge({unit_price_revenue: fixed_price, name: "#{li.name} (#{li.unit_price_revenue}%)", percentage_of_subtotal: false, parent_id: li.id}))
      end

      line_items_fixed_by_billable_party_including_add_ons(party, false).each do |li|
        li.document = document
        li.save
      end
    end

    def get_revenue_by_doc_type_and_party doc_type, party
      case doc_type
        when DocumentType::Event::invoice
          # fetches amount of revenue for non-invoiced items
          revenue_total_by_party party, true
        else
          # fetches amount of refenue for all line items
          revenue_total_by_party party
        end
    end

    def lock_line_items_tax_rate
      line_items.each {|li| li.lock_tax_rate}
    end

    def destroy_line_items line_items_to_destroy, allow_recursion=true
      # Remove the opposing line item ID
      line_items.select{|li| line_items_to_destroy.map{|li2| li2.id}.include?(li.opposing_line_item_id)}.map{|li| li.opposing_line_item = nil; li.save}
      # Remove the add on parent ID
      # Collect the list of add ons in case we have to delete them...
      add_ons = line_items_to_destroy.map{|li| li.add_ons}.flatten
      line_items.select{|li| line_items_to_destroy.map{|li2| li2.id}.include?(li.add_on_parent_id)}.map{|li| li.add_on_parent = nil; li.save}
      
      # If destroying line items with add-ons, destroy the add-ons first
      if allow_recursion
        destroy_line_items(add_ons, false) if add_ons.count > 0
      end
      # Destroy the line items
      line_items.destroy(line_items_to_destroy)
    end

    def update_status_after_manual_save
      if self.status == Status::Event.auto_generated
        self.status = Status::Event.proposed
        self.save
      end
    end

  private

    # Remove all Menu-Item and Menu-Fee line items from this vendor.  Most likely because a Menu-Template has been changed.
    # ---------------------------------------------------------------------------
    def remove_all_menu_type_line_items vendor_id
      # Remove all menu items where we are dealing with this vendor
      destroy_line_items(line_items.where(:payable_party_id => vendor_id, :line_item_sub_type => "Menu-Item", :payable_party_type => 'Vendor'))
      destroy_line_items(line_items.where(:billable_party_id => vendor_id, :line_item_sub_type => "Menu-Item", :billable_party_type => 'Vendor'))
      destroy_line_items(line_items.select{|li| (!li.inventory_item.nil? && li.inventory_item.vendor_id == vendor_id)})
      
      destroy_line_items(line_items.where(:payable_party_id => vendor_id, :line_item_sub_type => "Menu-Fee", :payable_party_type => 'Vendor'))
      destroy_line_items(line_items.where(:billable_party_id => vendor_id, :line_item_sub_type => "Menu-Fee", :billable_party_type => 'Vendor'))
      destroy_line_items(line_items.select{|li| (!li.menu_template.nil? && li.menu_template.vendor_id == vendor_id)})
    end

    # Fetch the event_vendor object for a given vendor_id.  It's possible that we don't
    # have an event_vendor for this vendor_id, so in that case, return nil
    # ---------------------------------------------------------------------------
    def fetch_event_vendor_by_vendor_id vendor_id
      if !event_vendors.nil? && event_vendors.find_all{|item| item.vendor_id == vendor_id }.count > 0
        event_vendors.find_all{|item| item.vendor_id == vendor_id }.first
      else
        nil
      end
    end

    # Process new event vendor - copy menu-level-discounts, generate line items
    # ---------------------------------------------------------------------------
    def process_event_vendor event_vendor
      # Copy the menu-discount-levels from the menu template to the event vendor container
      event_vendor.copy_menu_level_discounts_from_menu_template

      # Create line items for the menu items. A La Carte menus should not get line items here.
      if event_vendor.pricing_type == MenuPricingType.menu_level
        create_line_items_from_menu_template(event_vendor)
      end
    end

    # Create line items for each inventory item in the menu template.  If
    # the menu template is menu-level pricing, then also create a per-person charge
    # ---------------------------------------------------------------------------
    def create_line_items_from_menu_template event_vendor
      if !event_vendor.menu_template.nil?

        # If menu-level pricing, create the "per-person" line item, based on the initial participation
        if (event_vendor.menu_template.pricing_type == MenuPricingType.menu_level)
          line_items.push(create_line_item_for_per_person_charge_2(event_vendor.participation, event_vendor, true, true, ""))
        end

        # Create line items for each inventory item, but only if there is no grouping configured
        if !event_vendor.menu_template.menu_template_grouped && !event_vendor.menu_template.all_items
          event_vendor.menu_template.inventory_items.each do |item|
            line_items.push(create_line_item_from_inventory_item(item, 0, event_vendor.vendor, account, false, false, ""))
          end
        end
      end
    end

    # Create a "Goods" line item from an inventory item.
    # ---------------------------------------------------------------------------
    def create_line_item_from_inventory_item inventory_item, qty, payable_party, billable_party, include_price_in_expense, include_price_in_revenue, notes
      # Vendor
      l1 = LineItem.create!(
        :line_item_type => "Goods", :line_item_sub_type => "Menu-Item",
        :sku => inventory_item.sku, :name => inventory_item.name_vendor, :quantity => qty,
        :unit_price_expense => inventory_item.cogs,
        :tax_rate_expense => 0,
        :payable_party => payable_party,
        :include_price_in_expense => include_price_in_expense,
        :inventory_item => inventory_item, :notes => notes, :event => self)

      # Account
      l2 = LineItem.create!(
        :line_item_type => "Goods", :line_item_sub_type => "Menu-Item",
        :sku => inventory_item.sku, :name => inventory_item.name_public, :quantity => qty,
        :unit_price_revenue => calculate_sell_price_from_inventory_item(inventory_item),
        :billable_party => billable_party,
        :include_price_in_revenue => include_price_in_revenue,
        :inventory_item => inventory_item, :notes => notes, :event => self)

      l1.opposing_line_item = l2
      l2.opposing_line_item = l1
      l1.save
      l2.save

      [l1, l2]
    end

    # Create a "Goods" line item for a per-person charge
    # ---------------------------------------------------------------------------
    def create_line_item_for_per_person_charge_2 qty, event_vendor, include_price_in_expense, include_price_in_revenue, notes
      # Vendor
      l1 = LineItem.create!(
            :line_item_type => "Goods", :line_item_sub_type => "Menu-Fee",
            :sku => "MT-" + event_vendor.menu_template_id.to_s.rjust(7, '0'), :name => "* Per Person Charge (" + event_vendor.vendor.name + ")", :quantity => qty,
            :unit_price_expense => event_vendor.calculate_menu_level_cogs,
            :tax_rate_expense => 0,
            :payable_party => event_vendor.vendor,
            :include_price_in_expense => include_price_in_expense,
            :menu_template => event_vendor.menu_template, :event => self)

      # Account
      l2 = LineItem.create!(
            :line_item_type => "Goods", :line_item_sub_type => "Menu-Fee",
            :sku => "MT-" + event_vendor.menu_template_id.to_s.rjust(7, '0'), :name => "* Per Person Charge (" + event_vendor.vendor.name + ")", :quantity => qty,
            :unit_price_revenue => event_vendor.calculate_menu_level_sell_price,
            :billable_party => account,
            :include_price_in_revenue => include_price_in_revenue,
            :menu_template => event_vendor.menu_template, :event => self)

      l1.opposing_line_item = l2
      l2.opposing_line_item = l1
      l1.save
      l2.save
      
      [l1, l2]
    end

    # Create a "Goods" line item for a premium per-person charge
    # ---------------------------------------------------------------------------
    def create_line_item_premium_per_person_charge_2 event_vendor, inventory_item
      # Vendor
      l1 = LineItem.create!(
            :line_item_type => "Goods", :line_item_sub_type => "Menu-Fee",
            :sku => inventory_item.sku, :name => "Premium Charge", :quantity => 1,
            :unit_price_expense => inventory_item.premium_price,
            :tax_rate_expense => 0,
            :payable_party => inventory_item.vendor,
            :include_price_in_expense => true,
            :menu_template => event_vendor.menu_template, :event => self)

      # Account
      l2 = LineItem.create!(
            :line_item_type => "Goods", :line_item_sub_type => "Menu-Fee",
            :sku => inventory_item.sku, :name => "Premium Charge", :quantity => 1,
            :unit_price_revenue => calculate_sell_price_using_account_pricing_tier(inventory_item.premium_price),
            :billable_party => account,
            :include_price_in_revenue => true,
            :menu_template => event_vendor.menu_template, :event => self)

      l1.opposing_line_item = l2
      l2.opposing_line_item = l1
      l1.save
      l2.save
      
      [l1, l2]
    end

    # Calculate the sell price for an inventory item, using pricing tiers.  The
    # special case here is for perks, which uses the perks-sell-price value
    # in the inventory item.
    # ---------------------------------------------------------------------------
    def calculate_sell_price_from_inventory_item inventory_item
      if Product.find_parent(product) == "perks"
        inventory_item.perks_price
      else
        calculate_sell_price_using_account_pricing_tier(inventory_item.cogs)
      end
    end
end
