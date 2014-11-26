# == Schema Information
#
# Table name: vendors
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  legal_name                 :string(255)
#  description                :text
#  website                    :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  image_file_name            :string(255)
#  image_content_type         :string(255)
#  image_file_size            :integer
#  image_updated_at           :datetime
#  default_tax_rate           :decimal(, )      default(0.0), not null
#  address_id                 :integer
#  vendor_manager_id          :integer
#  bio                        :text
#  rating                     :decimal(2, 1)
#  review_count               :integer
#  rating_image_url           :string(255)
#  yelp_url                   :string(255)
#  yelp_id                    :string(255)
#  vendor_type                :string(255)      default("Restaurant")
#  vendor_minimum             :float            default(100.0)
#  concurrent_orders          :integer          default(2)
#  concurrent_orders_time     :integer          default(30)
#  managed_services_lead_time :decimal(, )      default(21.0)
#  fee                        :float
#  is_fixed                   :boolean          default(FALSE)
#  cap                        :float            default(100.0)
#

class Vendor < ApplicationModel
  include Fooda::Accounting
  include Fooda::Asset
  include Fooda::Search
  include SearchSortPaginate
  include Vendor::ReviewsCalculation
  
  global_site_search on: [:name, :legal_name, :"id::varchar(255)"]

  acts_as_payable
  acts_as_billable
  cattr_accessor :skip_callbacks
  
  has_many :inventory_items, :dependent => :destroy
  has_many :menu_templates, :dependent => :restrict
  has_many :event_vendors, :dependent => :restrict
  has_many :select_event_vendors, :dependent => :restrict
  has_many :contacts, :dependent => :destroy
  has_many :vendor_preferences, dependent: :destroy
  has_many :vendor_insurances, :dependent => :destroy

  has_many :product_types, :class_name => "VendorProductType", :dependent => :destroy
  has_many :products, :class_name => "VendorProduct", :dependent => :destroy
  has_many :issues, as: :subject
  has_images
  has_many :capacities
  has_and_belongs_to_many :reviews
  has_many :reviews_rollups, as: :reference

  has_reputation :favorite, source: :user

  belongs_to :address
  belongs_to :vendor_manager, :class_name => "User"

  accepts_nested_attributes_for :address, allow_destroy: true

  validates_presence_of :name, :default_tax_rate, :cuisine_list, :market_list, :vendor_manager_id
  validates_uniqueness_of :name

  default_scope order 'name'

  acts_as_ordered_taggable_on :cuisines
  acts_as_ordered_taggable_on :markets

  after_initialize :initial_values

  after_create :create_product_type_records
  after_create :create_all_item_menu_templates
  after_create :trigger_reviews_rollup

  after_save :update_yelp_attributes, :unless => :skip_callbacks
  after_save :update_menu_template_cuisine

  # Memcache Integration
  after_create  :inc_cache_counter
  after_update  :inc_cache_counter
  after_destroy :inc_cache_counter

  has_attached_file :image,
    :storage => :fog,
    :default_url => '/images/default_vendor.gif',
    :fog_credentials => {
      provider: "AWS",
      aws_access_key_id: AWS::Key,
      aws_secret_access_key: AWS::Secret,
      region: AWS::Region
    },
    :fog_public => true,
    :fog_directory => AWS::PublicBucket,
    :path => ":id.:extension"

  def to_search_result
    super.merge(:preview => "Vendor: " + self.pretty_id)
  end

  def to_s
    name
  end

  def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end

  def has_product? product
    products.where(product:product).count > 0
  end

  def product_type_config
    @product_type_config ||= product_types.inject({}) do |memo,product_type|
      setting = memo[product_type.product_type] = {
        "status" => product_type.status
      }

      product_type.products.collect(&:product).each do |product|
        setting[product] = true
      end

      memo
    end

  end

  # This will take a complex hash containing
  # configuration for each product type (i.e. perks, select, managed_services)
  # and make sure the product config state for each is properly stored in the database
  def product_type_config= config_hash
    @product_type_config = nil

    products.delete_all

    config_hash.each do |setting|
      product_type,settings = setting

      record = product_types.find_by_product_type(product_type)
      record.update_attribute(:status, settings.delete("status"))

      # removes any vendor products record, just so that
      # any values that are unchecked don't show up
      # in the vendor_products table.

      # for every product that was selected, we will create
      # a vendor_products record
      settings.keys.each do |product|
        products.create(product: product,product_type:product_type)
      end
    end

    # Always add the finance charge.
    products.create(product: Product.financial_m_s, product_type: ProductType.managed_services)
  end

  # creates status tracking records for each vendor product type
  def create_product_type_records
    ProductType.available_values.each do |product_type|
      unless product_types.where(product_type:product_type).count > 0
        product_types.create(product_type: product_type, status: "inactive")
      end
    end

    # Always add the finance charge.
    products.create(product: Product.financial_m_s, product_type: ProductType.managed_services)
  end

  def create_all_item_menu_templates

    mt = MenuTemplate.create!(
      :name => "A La Carte", :pricing_type => MenuPricingType.item_level, 
      :start_date => Date.today, :vendor_id => self.id, :product_type => ProductType.managed_services, 
      :cogs => 0, :sell_price => 0, :retail_price => 0, :all_items => true)

    menu_templates.push(mt)
  end

  def inventory_item_updated inventory_item
    menu_templates.each do |mt|
      mt.inventory_item_updated(inventory_item)
    end
  end

  def initial_values
    self.default_tax_rate ||= 0
    self.address ||= Address.new if self.new_record?
    self.fee ||= 10 unless self.is_fixed?
  end

  def billing_address
    result = ""
    return result if address.nil?

    result << "#{address.address1}<br>" unless address.address1.empty? 
    result << "#{address.address2}<br>" unless address.address2.empty?
    result << "#{address.city}, " unless address.city.empty?
    result << "#{address.state} " unless address.state.empty?
    result << "#{address.zip_code}" unless address.zip_code.empty?

    result.html_safe
  end

  def menu_templates_by_product product
    templates = menu_templates.select{|mt| mt.product_type == Product.find_parent(product) && (mt.start_date.nil? ? DateTime.parse('0001-01-01') : mt.start_date) <= DateTime.now && (mt.expiration_date.nil? ? DateTime.parse('9999-01-01') : mt.expiration_date) >= DateTime.now} 
    if product == ProductType.select
      templates.sort_by!{|h| h.is_default ? 0 : 1 }
    end
    templates
  end

  def inventory_items_by_product_type product_type
     inventory_items.select{|i| i.inventory_item_product_types.where(:product_type => product_type).count > 0}
  end

  def self.vendors_by_product_and_market product, market
    @vendors = Vendor.find_by_sql(["SELECT DISTINCT vendors.* FROM vendors 
      INNER JOIN vendor_products ON vendor_products.vendor_id = vendors.id 
      INNER JOIN vendor_product_types ON vendor_product_types.vendor_id = vendors.id
      INNER JOIN taggings ON vendors.id = taggings.taggable_id
      INNER JOIN tags ON taggings.tag_id = tags.id
      WHERE vendor_products.product = ? 
      AND vendor_product_types.product_type = ?
      AND vendor_product_types.status = 'active'
      AND taggings.taggable_type = 'Vendor'
      AND taggings.context = 'markets'
      AND tags.name = ?
      ORDER BY vendors.name", product, Product.find_parent(product), market] )
  end

  def self.vendors_by_type_and_product_and_market product, type, market
    @vendors = Vendor.find_by_sql(["SELECT DISTINCT vendors.* FROM vendors 
      INNER JOIN vendor_products ON vendor_products.vendor_id = vendors.id 
      INNER JOIN vendor_product_types ON vendor_product_types.vendor_id = vendors.id
      INNER JOIN taggings ON vendors.id = taggings.taggable_id
      INNER JOIN tags ON taggings.tag_id = tags.id
      WHERE vendor_products.product = ? 
      AND vendors.vendor_type = ?
      AND vendor_product_types.product_type = ?
      AND vendor_product_types.status = 'active'
      AND taggings.taggable_type = 'Vendor'
      AND taggings.context = 'markets'
      AND tags.name = ?
      ORDER BY vendors.name", product, type, Product.find_parent(product), market] )
  end

  def self.vendors_by_product product
    @vendors = Vendor.find_by_sql(["SELECT DISTINCT vendors.* FROM vendors 
      INNER JOIN vendor_products ON vendor_products.vendor_id = vendors.id 
      INNER JOIN vendor_product_types ON vendor_product_types.vendor_id = vendors.id
      WHERE vendor_products.product = ? 
      AND vendor_product_types.product_type = ? 
      AND vendor_product_types.status = 'active'
      ORDER BY vendors.name", product, Product.find_parent(product) ])
  end

  def self.get_vendors_by_cuisine_and_product_and_location_and_account cuisine, product, location_id, account_id
    if defined?(Location.find(location_id).building.market.name)
      vendors = Vendor.vendors_by_product_and_market(product, Location.find(location_id).building.market.name)
      vendors = vendors.select{|v| v.cuisine_list.include?(cuisine)} if cuisine != "Any"

      account = Account.find(account_id)

      favorite_vendors = account.favorite_vendors.sort & vendors
      do_not_schedule_vendors = account.do_not_schedule_vendors.sort & vendors
      vendors_neutral = vendors - favorite_vendors - do_not_schedule_vendors

      @vendors = {}
      @vendors["Favorite Vendors"] = favorite_vendors unless favorite_vendors.count < 1
      @vendors["Neutral"] = vendors_neutral unless vendors_neutral.count < 1
      @vendors["Do Not Schedule"] = do_not_schedule_vendors unless do_not_schedule_vendors.count < 1

      @vendors
    else
      []
    end
  end

  def accounts_favorite
    self.vendor_preferences.where(preference_type: Fooda::Preferences::Vendor.account, disposition: Fooda::Preferences::Disposition.favorite).map{|v| v.account}
  end

  def accounts_do_not_schedule
    self.vendor_preferences.where(preference_type: Fooda::Preferences::Vendor.account, disposition: Fooda::Preferences::Disposition.do_not_schedule).map{|v| v.account}
  end

  def location_favorite
    self.vendor_preferences.where(preference_type: Fooda::Preferences::Vendor.location, disposition: Fooda::Preferences::Disposition.favorite).map{|c| c.location}
  end

  def location_do_not_schedule
    self.vendor_preferences.where(preference_type: Fooda::Preferences::Vendor.location, disposfition: Fooda::Preferences::Disposition.do_not_schedule).map{|c| c.location}
  end

  def default_url
    '/images/default_vendor.gif'
  end

  def default_image
    self.assets.where(:is_default => true).first
  end

  def default_url
    '/images/default_vendor.gif'
  end

  def default_image
    self.assets.where(:is_default => true).first
  end
  
  def update_yelp_attributes
    self.yelp_id.nil? ? (self.address.city.empty? ? nil : Yelp.find(self)) : Yelp.update(self)
  end

  def update_menu_template_cuisine
    self.menu_templates.map{|mt| mt.cuisine = self.cuisine_list[0]; mt.save}
  end
  
  def yelp_id=(id)
    self[:yelp_id] = id.split("www.yelp.com/biz/").last unless id.nil?
  end
  
  def delivery_fee
    is_fixed? ? [fee,'$'] : [fee, '%', cap]
  end
  
  def is_eligible_for_catering?
    self.product_types.select{|pt| pt.product_type == 'managed_services' && pt.status == 'active'}.length > 0
  end
  
  def is_available_for_catering? event_date
    # We use the Central Time zone here but this will need to change. 
    final_timezone = 'Central Time (US & Canada)'
    Chronic.time_class = ActiveSupport::TimeZone[final_timezone]
    
    start_datetime = Chronic.parse(event_date)
    start_time = start_datetime.strftime('%T')

    # Is the Vendor open that day?
    week_day = start_datetime.wday - 1
    week_day = 6 if week_day < 0
    capacity = Capacity.where("vendor_id = ? AND day = ? AND is_closed = ? AND start_time <= ? AND end_time >= ?", self.id, week_day, false, start_time, start_time)
    unless capacity.length > 0
      return false
    end

    # Lead time good enough? Convert both timestamps to
    # UTC for correct calculations.
    expected_lead_time = ((start_datetime.utc - Time.now.utc) / 3600).ceil
    # Subtract 19 hours from RHS of equation effectively inflating the 
    # Expected Lead Time to ~40 hours for Monday's events incl. 
    # the default Vendor Lead Time of 21 hours. (per Jimmy's request)
    expected_lead_time -= 19 if week_day == 0
    
    unless expected_lead_time >= self.managed_services_lead_time
      return false
    end

    # Max. Concurrent Capacity breached?
    max_concurrent_orders = self.concurrent_orders # No. of orders
    concurrent_orders_time = self.concurrent_orders_time # in X minutes
    concurrent_orders_time_sec = concurrent_orders_time * 60 # in X seconds 
    
    # Setup Ordering window start & stop time based on event_date
    order_window_start = (start_datetime - concurrent_orders_time_sec).strftime('%F %T')
    order_window_end = start_datetime.strftime('%F %T')
    
    # Find Scheduled/Active Events associated with this Vendor 
    # between order_window_start & order_window_end.
    conditions = ["vendor_id = ? AND events.event_start_time >= ? AND events.event_end_time <= ? AND events.status IN (?)", self.id, order_window_start, order_window_end, ['scheduled', 'active']]
    events = EventVendor.find(:all, :include => [:event], :conditions => conditions)

    if events.length >= max_concurrent_orders
      # Vendor already has more than max_concurrent_orders within window!
      return false
    end

    # If all the checks pass, then return TRUE!
    true
  end

  public

    def all_vendors_options
      cid = 'Vendors_All_' + self.get_cache_counter.to_s
      if ENV['disable_caching'] == '1' || (vendor_names = Rails.cache.read(cid)).nil?
        vendor_names = ["Any"].concat(Vendor.where("id IN (?)", MenuTemplate.where("is_eligible_for_self_service = 'true'").pluck("DISTINCT vendor_id")).collect{|c| [c.name, c.id]})
        Rails.cache.write(cid, vendor_names, expires_in: 1.week)
      end
      vendor_names
    end
end
