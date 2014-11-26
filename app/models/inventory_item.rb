# == Schema Information
#
# Table name: inventory_items
#
#  id                    :integer          not null, primary key
#  name_vendor           :string(255)
#  description           :text
#  sku                   :string(255)
#  featured              :boolean
#  type                  :string(255)
#  image                 :string(255)
#  vendor_id             :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  meal_type             :string(20)
#  cogs_cents            :integer
#  perks_price_cents     :integer
#  retail_price_cents    :integer
#  name_public           :string(255)
#  premium_price_cents   :integer          default(0), not null
#  inventory_item_option :boolean          default(FALSE), not null
#  min_feeds             :integer          default(1)
#  max_feeds             :integer
#  packaging_details     :string(255)      default("Family Style")
#  min_quantity          :integer          default(0), not null
#  eligible_for_add_ons  :boolean
#

class InventoryItem < ApplicationModel
  include Fooda::Asset
  
	belongs_to :vendor
  
  has_many :menu_template_inventory_items, :dependent => :restrict
  has_many :menu_templates, :through => :menu_template_inventory_items

  has_many :inventory_item_product_types, :dependent => :destroy
  has_images

  has_many :inventory_items_option_groups, :dependent => :restrict
  has_many :option_groups, :dependent => :destroy
  has_many :reviews, :as => :reviewable, :dependent => :restrict

  default_scope order 'name_vendor'

  acts_as_taggable
  acts_as_taggable_on :external_tags
  acts_as_taggable_on :dietary_restrictions
  acts_as_taggable_on :options

  validates :cogs_cents, :numericality => true
  validates :perks_price_cents, :numericality => true
  validates :retail_price_cents, :numericality => true
  validates :premium_price_cents, :numericality => true

  validates :name_vendor, :presence => true
  validates :name_public, :presence => true

  validates_presence_of :cogs_cents
  validates_presence_of :perks_price_cents
  validates_presence_of :retail_price_cents
  validates_presence_of :premium_price_cents

  monetize :cogs_cents
  monetize :perks_price_cents
  monetize :retail_price_cents
  monetize :premium_price_cents

  after_initialize :initial_values
  after_create :generate_sku
  after_save :alert_vendor_of_updated_inventory_item

  validates_inclusion_of :meal_type, :in => MealType.available_values

  # To find eligible add-ons items
  scope :eligible, lambda{ where(eligible_for_add_ons: true)}

  def default_image
    self.assets.where(:is_default => true).first
  end

  def product_types_allowed= hash
    inventory_item_product_types.clear
    hash.each do |product_type|
      inventory_item_product_types.push(InventoryItemProductType.new(:product_type => product_type.first))
    end
  end

  def calculate_sell_price_using_standard_pricing_tier
    pricingTier = PricingTier.where(name: "Standard").first
    sell_price = self.cogs / (1 - pricingTier.gross_profit / 100.0)
  end

  def update_option_group_inventory_items option_group, inventory_item_ids
    option_group.inventory_items.clear
    inventory_item_ids.each { |id| option_group.inventory_items << InventoryItem.find(id) } unless inventory_item_ids.nil?
  end

  def remove_option_groups
    self.option_groups.destroy_all
  end

  def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end

  private

    def initial_values
      self.cogs_cents  ||= 0
      self.perks_price_cents  ||= 0
      self.retail_price_cents  ||= 0
      self.premium_price_cents ||= 0
      self.name_public ||= self.name_vendor
    end

    def generate_sku
      self.sku = "II-" + self.id.to_s.rjust(7, '0')
      self.save
    end

    def alert_vendor_of_updated_inventory_item
      vendor.inventory_item_updated(self)
    end

end
