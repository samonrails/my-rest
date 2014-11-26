# == Schema Information
#
# Table name: event_vendors
#
#  id                              :integer          not null, primary key
#  event_id                        :integer
#  vendor_id                       :integer
#  participation                   :integer
#  menu_template_id                :integer
#  pricing_type                    :string(255)
#  default_menu_cogs_cents         :integer
#  default_menu_sell_price_cents   :integer
#  default_menu_retail_price_cents :integer
#  external_vendor_notes           :text
#  event_transaction_method_id     :integer
#  vendor_billing_summary_sent_at  :datetime
#

class EventVendor < ApplicationModel
  belongs_to :event
  belongs_to :vendor
  belongs_to :menu_template
  belongs_to :event_transaction_method, :dependent => :destroy

  has_many :menu_level_discounts, :dependent => :destroy

  validates :default_menu_cogs_cents, :numericality => true
  validates :default_menu_sell_price_cents, :numericality => true
  validates :default_menu_retail_price_cents, :numericality => true

  validates_presence_of :default_menu_cogs_cents
  validates_presence_of :default_menu_sell_price_cents
  validates_presence_of :default_menu_retail_price_cents

  monetize :default_menu_cogs_cents
  monetize :default_menu_sell_price_cents
  monetize :default_menu_retail_price_cents

  after_initialize :initial_values
  before_update :vendor_participation_change
  after_commit :reindex_es_async

  public
    
    # Copy the menu-level discounts from the menu-template to the event vendor
    # object.  This is done to preserve the snap-shot in time concept, as well
    # as to allow for editting of menu-level discounts without messing with
    # the menu template.
    # ---------------------------------------------------------------------------
    def copy_menu_level_discounts_from_menu_template
      menu_level_discounts.clear
      menu_template.menu_level_discounts.each do |mld|
        create_menu_level_discount(mld)
      end
    end

    # Determine the menu-level cogs based on participation and 
    # menu-level discounts.
    # ---------------------------------------------------------------------------
    def calculate_menu_level_cogs
      price = default_menu_cogs
      participation_level = 0

      menu_level_discounts.each do |menu_level_discount|
        if participation >= menu_level_discount.min_participation && menu_level_discount.min_participation > participation_level
          price = menu_level_discount.cogs
          participation_level = menu_level_discount.min_participation
        end
      end
      price
    end

    # Determine the menu-level sell price based on participation and 
    # menu-level discounts.  
    # ---------------------------------------------------------------------------
    def calculate_menu_level_sell_price
      price = default_menu_sell_price
      participation_level = 0

      menu_level_discounts.each do |menu_level_discount|
        if participation >= menu_level_discount.min_participation && menu_level_discount.min_participation > participation_level
          price = menu_level_discount.sell_price
          participation_level = menu_level_discount.min_participation
        end
      end
      price
    end

    # Determine if any line items have been invoiced for this event vendor
    # ---------------------------------------------------------------------------
    def invoiced_line_items?
      event.line_items.select{|li| !li.document_id.nil? && 
        (li.payable_party == self.vendor || 
          li.billable_party == self.vendor || 
          (!li.inventory_item.nil? && li.inventory_item.vendor == self.vendor) || 
          (!li.menu_template.nil? && li.menu_template.vendor == self.vendor))}.count > 0
    end

    def reindex_es_async
      Elasticsearch.reindex "Event", self.event_id
    end

  private

    # Create a menu-level discount setting the sell price based on the event
    # account pricing tiers
    # ---------------------------------------------------------------------------
    def create_menu_level_discount menu_level_discount
      sell_price = event.calculate_sell_price_using_account_pricing_tier(menu_level_discount.cogs)
      menu_level_discounts.create(menu_level_discount.attributes.merge({:menu_template_id => nil, :sell_price => sell_price}))
    end

    def initial_values
      self.default_menu_cogs_cents  ||= 0
      self.default_menu_sell_price_cents  ||= 0
      self.default_menu_retail_price_cents  ||= 0
      self.event_transaction_method  ||= EventTransactionMethod.new
      self.external_vendor_notes ||= ""
    end

    def vendor_participation_change
      self.event.vendor_participation_change(self)
    end

end
