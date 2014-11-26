# == Schema Information
#
# Table name: menu_templates
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  pricing_type                 :string(255)
#  expiration_date              :date
#  start_date                   :date             not null
#  vendor_id                    :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  product_type                 :string(20)
#  cogs_cents                   :integer
#  sell_price_cents             :integer
#  retail_price_cents           :integer
#  expires                      :boolean
#  all_items                    :boolean          default(FALSE), not null
#  is_eligible_for_self_service :boolean          default(FALSE), not null
#  description                  :text
#  min_quantity                 :integer          default(0), not null
#  cuisine                      :string(255)
#  dietary_restrictions         :text
#  external_tags                :text
#  is_default                   :boolean          default(FALSE)
#

class MenuTemplate < ApplicationModel
  include Fooda::Asset

  belongs_to :vendor

  # if an event is referenced - the menu template cannot be deleted
  has_many :event_vendors, :dependent => :restrict
  has_many :menu_template_inventory_items, :dependent => :destroy
  has_many :inventory_items, :through => :menu_template_inventory_items

  has_many :menu_level_discounts, :dependent => :destroy
  has_many :menu_template_groups, :dependent => :destroy
  has_images

  has_and_belongs_to_many :users

  has_reputation :favorite, source: :user
  has_images

  acts_as_taggable_on :meal_periods

  accepts_nested_attributes_for :menu_level_discounts, allow_destroy: true

  validates :cogs_cents, :numericality => true
  validates :sell_price_cents, :numericality => true
  validates :retail_price_cents, :numericality => true

  validates_presence_of :start_date
  validates_presence_of :cogs_cents
  validates_presence_of :sell_price_cents
  validates_presence_of :retail_price_cents

  validates_inclusion_of :product_type, :in => ProductType.available_values

  # default_scope order 'name'

  monetize :cogs_cents
  monetize :sell_price_cents
  monetize :retail_price_cents
  serialize :meal_period, Array

  after_initialize :initial_values

  # Memcache Integration
  after_create  :inc_cache_counter
  after_update  :inc_cache_counter
  after_destroy :inc_cache_counter

  public

    def to_s
      name
    end

    def name_and_product_type
       "#{ name + ' (' + product_type + ')' }"
    end

    def menu_template_grouped
      menu_template_groups.count > 0
    end

    def menu_template_groups_with_inventory_items
      menu_template_inventory_items
        .select{ |mtii| (!mtii.menu_template_group_id.nil?) }
        .uniq{ |mtii| mtii.menu_template_group_id }
        .map{ |mtii| mtii.menu_template_group }
    end

    def menu_template_inventory_items_by_group group_id
      menu_template_inventory_items.select{ |mtii| (mtii.menu_template_group_id == group_id) }.map{|mtii| mtii.inventory_item}
    end

    def menu_template_inventory_item_ids_by_group group_id
      menu_template_inventory_items.select{ |mtii| (mtii.menu_template_group_id == group_id) }.map{|mtii| mtii.inventory_item_id}
    end

    def inventory_items_with_no_group
      menu_template_inventory_items.select{ |mtii| (mtii.menu_template_group_id.nil?) }.map{|mtii| mtii.inventory_item}
    end

    def are_selections_valid selections
      if selections.nil?
        return false
      end

      menu_template_groups.each do |mtg|
        if (((menu_template_inventory_item_ids_by_group(mtg.id) & selections.collect{|i| i.to_i}).count > mtg.choices_to_select) || (selections.count < 1))
          return false
        end
      end
      true
    end

    def update_menu_template_group_inventory_items menu_template_group, inventory_item_ids
      menu_template_inventory_items_to_delete = menu_template_inventory_items.find_all{|item| item.menu_template_group == menu_template_group }
      menu_template_inventory_items.destroy(menu_template_inventory_items_to_delete)

      unless inventory_item_ids.nil?
        inventory_item_ids.each do |id|
          menu_template_inventory_items.create!(:inventory_item => InventoryItem.find(id), :menu_template_group => menu_template_group)
        end
      end
      update_dietary_restrictions
      update_external_tags
    end

    def inventory_item_updated inventory_item
      if inventory_item.inventory_item_product_types.where(:product_type => product_type).count == 0 or inventory_item.inventory_item_option
        # The inventory item is not permissioned for our product type or it is an add on item so make sure it is not in our list.
        self.inventory_items = self.inventory_items - [inventory_item]
      else
        # The inventory item is permissioned for our product_type.  Add to the menu_template
        # if the menu_template is "all_items" and does not yet contain the inventory item.
        if self.all_items && (inventory_items.where(:id => inventory_item.id).count == 0)
          # Add the inventory item
          self.inventory_items.push(inventory_item)
        end
      end
      update_dietary_restrictions
      update_external_tags
    end

    def update_dietary_restrictions
      self.dietary_restrictions = self.inventory_items.map{|i| i.dietary_restriction_list}.flatten.uniq.join(",")
      self.save
    end

    def update_external_tags
      self.external_tags = self.inventory_items.map{|i| i.external_tag_list}.flatten.uniq.join(",")
      self.save
    end

    def min_participation_quantity user=nil
      min_qty = self.min_quantity.to_i
      if min_qty == 0
        # Min. Quantity NOT specified in the MT
        # Calculate based on Vendor Minimums instead.
        min_qty = self.vendor.vendor_minimum / Pricing.catering_sell_price(self.cogs, user).to_s.to_f if self.cogs != 0
        min_qty = [min_qty, self.min_quantity.to_i].max if self.pricing_type == MenuPricingType.menu_level      
      end
      min_qty.ceil
    end

    def calculate_sell_price_using_standard_pricing_tier
      pricingTier = PricingTier.where(name: "Standard").first
      sell_price = self.cogs / (1 - pricingTier.gross_profit / 100.0)
    end

    def default_image
      self.assets.where(:is_default => true).first
    end

    def calculate_menu_level_discount_cogs participation
      price = self.cogs
      participation_level = 0

      return price if participation.nil?

      self.menu_level_discounts.each do |menu_level_discount|
        if participation >= menu_level_discount.min_participation && menu_level_discount.min_participation > participation_level
          price = menu_level_discount.cogs
          participation_level = menu_level_discount.min_participation
        end
      end
      price
    end

  private
    def initial_values
      self.cogs_cents  ||= 0
      self.sell_price_cents  ||= 0
      self.retail_price_cents  ||= 0
    end

end
